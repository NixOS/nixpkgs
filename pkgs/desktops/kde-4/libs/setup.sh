addKDEDIRS()
{
	addToSearchPath KDEDIRS /share/kde4 /. $1
}

fixCmakeDbusCalls()
{
	dbusPrefix=${1:-@out@}
	echo "Fixing dbus calls in CMakeLists.txt files"
# Trailing slash in sed is essential
	find .. -name CMakeLists.txt \
	| xargs sed -e "s#\${DBUS_INTERFACES_INSTALL_DIR}/#${dbusPrefix}/share/dbus-1/interfaces/#" -i
}
envHooks=(${envHooks[@]} addKDEDIRS)
