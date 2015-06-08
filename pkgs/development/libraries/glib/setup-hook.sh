# Install gschemas, if any, in a package-specific directory
installFlagsArray+=("gsettingsschemadir=$out/share/gsettings-schemas/$name/glib-2.0/schemas/")

make_glib_find_gsettings_schemas() {
    # For packages that need gschemas of other packages (e.g. empathy)
    if [ -d "$1"/share/gsettings-schemas/*/glib-2.0/schemas ]; then
        addToSearchPath GSETTINGS_SCHEMAS_PATH "$1/share/gsettings-schemas/"*
    fi
}

envHooks+=(make_glib_find_gsettings_schemas)

glibPreFixupPhase() {
    addToSearchPath GSETTINGS_SCHEMAS_PATH "$out/share/gsettings-schemas/$name"
}

preFixupPhases="$preFixupPhases glibPreFixupPhase"
