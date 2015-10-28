
make_glib_find_gsettings_schemas() {
    # For packages that need gschemas of other packages (e.g. empathy)
    if [ -d "$1"/share/gsettings-schemas/*/glib-2.0/schemas ]; then
        addToSearchPath GSETTINGS_SCHEMAS_PATH "$1/share/gsettings-schemas/"*
    fi
}
envHooks+=(make_glib_find_gsettings_schemas)

# Install gschemas, if any, in a package-specific directory
glibPreInstallPhase() {
  installFlagsArray+=("gsettingsschemadir=${!outputLib}/share/gsettings-schemas/$name/glib-2.0/schemas/")
}
preInstallPhases+=(glibPreInstallPhase)

glibPreFixupPhase() {
    # Move gschemas in case the install flag didn't help
    if [ -d "${!outputLib}/share/glib-2.0/schemas" ]; then
        mkdir -p "${!outputLib}/share/gsettings-schemas/$name/glib-2.0"
        mv "${!outputLib}/share/glib-2.0/schemas" "${!outputLib}/share/gsettings-schemas/$name/glib-2.0/"
    fi

    addToSearchPath GSETTINGS_SCHEMAS_PATH "${!outputLib}/share/gsettings-schemas/$name"
}
preFixupPhases+=(glibPreFixupPhase)

