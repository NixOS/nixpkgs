addKDEDIRS()
{
	addToSearchPath KDEDIRS /share/kde4 /. $1
}
envHooks=(${envHooks[@]} addKDEDIRS)
