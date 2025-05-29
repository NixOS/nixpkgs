if [ -z "${EM_CACHE}" ]
then
  export EM_CACHE="/tmp/$(basename $(realpath $(dirname $(which emcc))/..))_cache"
  cp -r $(dirname $(which emcc))/../share/emscripten/cache $EM_CACHE
  chmod +rwX -R $EM_CACHE
fi
