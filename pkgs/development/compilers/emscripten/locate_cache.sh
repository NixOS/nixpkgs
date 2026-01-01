<<<<<<< HEAD
export EM_CACHE=${EM_CACHE:-"/tmp/$(basename $(realpath $(dirname $(command -v emcc))/..))_cache"}
=======
export EM_CACHE=${EM_CACHE:-"/tmp/$(basename $(realpath $(dirname $(which emcc))/..))_cache"}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
