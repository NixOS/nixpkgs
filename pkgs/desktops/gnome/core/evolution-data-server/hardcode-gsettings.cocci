/**
 * Since Nix does not have a standard location like /usr/share,
 * where GSettings system could look for schemas, we need to point the software to a correct location somehow.
 * For executables, we handle this using wrappers but this is not an option for libraries like e-d-s.
 * Instead, we hardcode the schema path when creating the settings.
 */

@initialize:python@
@@

cpp_constants = {}

def register_cpp_constant(const_name, val):
    cpp_constants[const_name] = val.strip()

def resolve_cpp_constant(const_name):
    return cpp_constants.get(const_name, const_name)

e_s_d_schema_constants = [
    # The following are actually part of e-d-s, despite the name.
    # We rename the old ambiguos constant name in ./prepare-for-gsettings-patching.patch
    "\"org.gnome.Evolution.DefaultSources\"",
    "\"org.gnome.evolution.shell.network-config\"",
]

g_d_s_schema_constants = [
    "\"org.gnome.system.proxy\"",
]

def get_schema_directory(schema_path):
    # Sometimes the schema id is referenced using C preprocessor #define constant in the same file
    # let’s try to resolve it first.
    schema_path = resolve_cpp_constant(schema_path.strip())
    if schema_path.startswith("\"org.gnome.evolution-data-server") or schema_path in e_s_d_schema_constants:
        return "\"@EDS_GSETTINGS_PATH@\""
    elif schema_path in g_d_s_schema_constants:
        return "\"@GDS_GSETTINGS_PATH@\""
    raise Exception(f"Unknown schema path {schema_path}")


@find_cpp_constants@
identifier const_name;
expression val;
@@

#define const_name val

@script:python record_cpp_constants depends on find_cpp_constants@
const_name << find_cpp_constants.const_name;
val << find_cpp_constants.val;
@@

register_cpp_constant(const_name, val)


@depends on ever record_cpp_constants || never record_cpp_constants@
// We want to run after #define constants have been collected but even if there are no #defines.
expression SCHEMA_PATH;
expression settings;
// Coccinelle does not like autocleanup macros in + sections,
// let’s use fresh id with concatenation to produce the code as a string.
fresh identifier schema_source_decl = "g_autoptr(GSettingsSchemaSource) " ## "schema_source";
fresh identifier schema_decl = "g_autoptr(GSettingsSchema) " ## "schema";
fresh identifier SCHEMA_DIRECTORY = script:python(SCHEMA_PATH) { get_schema_directory(SCHEMA_PATH) };
@@
-settings = g_settings_new(SCHEMA_PATH);
+{
+	schema_source_decl;
+	schema_decl;
+	schema_source = g_settings_schema_source_new_from_directory(SCHEMA_DIRECTORY,
+	                                                            g_settings_schema_source_get_default(),
+	                                                            TRUE,
+	                                                            NULL);
+	schema = g_settings_schema_source_lookup(schema_source, SCHEMA_PATH, FALSE);
+	settings = g_settings_new_full(schema, NULL, NULL);
+}
