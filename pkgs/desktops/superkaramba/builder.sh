source $stdenv/setup

echo $xlibs2
echo $x_libraries_env

postConfigure() {
  pwd;
  ls -l super*/src/Makefile;
  x_libraries_env_s=$(echo $x_libraries_env | sed 's/\//\\\//g')
  sed -e "s/x_libraries = \/usr\/lib/x_libraries = $x_libraries_env_s/" -i super*/src/Makefile;
  sed -e "s/x_libraries = \/usr\/lib/x_libraries = $x_libraries_env_s/" -i super*/Makefile;
  sed -e "s/x_libraries = \/usr\/lib/x_libraries = $x_libraries_env_s/" -i Makefile;
}

genericBuild
