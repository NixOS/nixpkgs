
make_glib_find_gsettings_schemas() {
    # For packages that need gschemas of other packages (e.g. empathy)
    for maybe_dir in "$1"/share/gsettings-schemas/*; do
        if [[ -d "$maybe_dir/glib-2.0/schemas" ]]; then
            addToSearchPath GSETTINGS_SCHEMAS_PATH "$maybe_dir"
        fi
    done
}
addEnvHooks "$hostOffset" make_glib_find_gsettings_schemas

# Install gschemas, if any, in a package-specific directory
glibPreInstallPhase() {
  makeFlagsArray+=("gsettingsschemadir=${!outputLib}/share/gsettings-schemas/$name/glib-2.0/schemas/")
}
preInstallPhases+=" glibPreInstallPhase"

glibPreFixupPhase() {
    # Move gschemas in case the install flag didn't help
    if [ -d "$prefix/share/glib-2.0/schemas" ]; then
        mkdir -p "${!outputLib}/share/gsettings-schemas/$name/glib-2.0"
        mv "$prefix/share/glib-2.0/schemas" "${!outputLib}/share/gsettings-schemas/$name/glib-2.0/"
    fi

    addToSearchPath GSETTINGS_SCHEMAS_PATH "${!outputLib}/share/gsettings-schemas/$name"
}

# gappsWrapperArgsHook expects GSETTINGS_SCHEMAS_PATH variable to be set by this.
# Until we have dependency mechanism in generic builder, we need to use this ugly hack.
if [[ " ${preFixupPhases:-} " =~ " gappsWrapperArgsHook " ]]; then
    preFixupPhases+=" "
    preFixupPhases="${preFixupPhases/ gappsWrapperArgsHook / glibPreFixupPhase gappsWrapperArgsHook }"
else
    preFixupPhases+=" glibPreFixupPhase"
fi
