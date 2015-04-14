# Install gschemas, if any, in a package-specific directory
installFlagsArray+=("gsettingsschemadir=$out/share/gsettings-schemas/$name/glib-2.0/schemas/")

make_glib_find_gsettings_schemas() {
    # For packages that need gschemas of other packages (e.g. empathy)
    if [ -d "$1"/share/gsettings-schemas/*/glib-2.0/schemas ]; then
        addToSearchPath GSETTINGS_SCHEMAS_PATH "$1/share/gsettings-schemas/"*
    fi
}

envHooks+=(make_glib_find_gsettings_schemas)

glibFixupPhase() {
    # Move gschemas in case the install flag didn't help
    if [ -d "$prefix/share/glib-2.0/schemas" ]; then
        mkdir -p "$prefix/share/gsettings-schemas/$name/glib-2.0"
        mv "$prefix/share/glib-2.0/schemas" "$prefix/share/gsettings-schemas/$name/glib-2.0/"
    fi

    addToSearchPath GSETTINGS_SCHEMAS_PATH "$prefix/share/gsettings-schemas/$name"
}

fixupOutputHooks+=(glibFixupPhase)

