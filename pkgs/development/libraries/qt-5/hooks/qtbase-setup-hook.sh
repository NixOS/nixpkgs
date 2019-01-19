qtPluginPrefix=@qtPluginPrefix@
qtQmlPrefix=@qtQmlPrefix@
qtDocPrefix=@qtDocPrefix@

. @fix_qt_builtin_paths@
. @fix_qt_module_paths@

providesQtRuntime() {
    [ -d "$1/$qtPluginPrefix" ] || [ -d "$1/$qtQmlPrefix" ]
}

# Build tools are often confused if QMAKE is unset.
QMAKE=@dev@/bin/qmake
export QMAKE

QMAKEPATH=
export QMAKEPATH

QMAKEMODULES=
export QMAKEMODULES

addToQMAKEPATH() {
    if [ -d "$1/mkspecs" ]; then
        QMAKEMODULES="${QMAKEMODULES}${QMAKEMODULES:+:}/mkspecs"
        QMAKEPATH="${QMAKEPATH}${QMAKEPATH:+:}$1"
    fi
}

# Propagate any runtime dependency of the building package.
# Each dependency is propagated to the user environment and as a build
# input so that it will be re-propagated to the user environment by any
# package depending on the building package. (This is necessary in case
# the building package does not provide runtime dependencies itself and so
# would not be propagated to the user environment.)
qtEnvHook() {
    addToQMAKEPATH "$1"
    if providesQtRuntime "$1"; then
        if [ "z${!outputBin}" != "z${!outputDev}" ]; then
            propagatedBuildInputs+=" $1"
        fi
        propagatedUserEnvPkgs+=" $1"
    fi
}
envHostTargetHooks+=(qtEnvHook)

postPatchMkspecs() {
    local bin="${!outputBin}"
    local dev="${!outputDev}"
    local doc="${!outputDoc}"
    local lib="${!outputLib}"

    moveToOutput "mkspecs" "$dev"

    if [ -d "$dev/mkspecs/modules" ]; then
        fixQtModulePaths "$dev/mkspecs/modules"
    fi

    if [ -d "$dev/mkspecs" ]; then
        fixQtBuiltinPaths "$dev/mkspecs" '*.pr?'
    fi
}
if [ -z "$dontPatchMkspecs" ]; then
    postPhases="${postPhases}${postPhases:+ }postPatchMkspecs"
fi

_Qt_sortless_uniq() {
	# `uniq`, but keeps initial order.
	# This is to remove risks of combinatorial explosion of plugin paths.
	cat -n | sort -uk2 | sort -nk1 | cut -f2-
}

_QtGetPluginPaths() {
	# Lists all plugin paths for current Qt for given buildInputs and propagatedBuildInputs
	local i
	local _i
	local o
	local inputs

	# FIXME : this causes output path cycles...
	# I am unsure if it is even needed, though.
	## Outputs self's plugins paths
	#for o in $outputs; do
	#	o="${!o}/@qtPluginPrefix@"
	#	if [ -e "$o" ]; then
	#		echo "$o"
	#	fi
	#done

	inputs="$(
		for i in $buildInputs $propagatedBuildInputs; do
			echo "$i"
		done | uniq
	)"

	for i in $inputs; do
		_i="$i/@qtPluginPrefix@"
		if [ -e "$_i" ]; then
			echo "$_i"
		fi
		_i="$i/nix-support/qt-plugin-paths"
		if [ -e "$_i" ]; then
			cat "$_i"
		fi
	done
}

postAddPluginPaths() {
	# Dumps all plugins paths to a nix-support file inside all outputs.
	local o

	for o in $outputs; do
		o="${!o}/nix-support"
		mkdir -p "$o"
		_QtGetPluginPaths | _Qt_sortless_uniq > $o/qt-plugin-paths
	done
}

if [ -z "$dontAddPluginPaths" ]; then
    postPhases="${postPhases}${postPhases:+ }postAddPluginPaths"
fi
