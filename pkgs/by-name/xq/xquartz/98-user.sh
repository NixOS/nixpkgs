if [ -d "${HOME}/.xinitrc.d" ] ; then
    for f in "${HOME}"/.xinitrc.d/*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi
