{ lib

, buildBazelPackage
, bazel

, buildPythonPackage
, fetchFromGitHub
, python

, cython

, numpy
, scipy
, six
}:

let

  pname = "jaxlib";
  version = "0.1.49";

  meta = {
    description = "XLA library for JAX";
    homepage = "https://github.com/google/jax";
    license = lib.licenses.asl20;    
  };

  bazel-build = buildBazelPackage {
    name = "bazel-build-${pname}-${version}";

    bazel = bazel;

    src = fetchFromGitHub {
        owner = "google";
        repo = "jax";
        rev = "${pname}-v${version}";
        sha256 = "1j792snw70l1pgqyqrpidg686140z1xmd2i7bj61yl4rnyxdr842";
    };

    nativeBuildInputs = [
        cython
    ];

    propagatedBuildInputs = [
        numpy
        scipy
        six
    ];

    bazelTarget = "//jaxlib";

    buildAttrs = {
      outputs = [ "out" ];
    };

    fetchAttrs = {
      sha256 = "09j57w6kc0vkfcdwr0qggy3qgrgq82kfa2jrwvvcnij4bl3wj40l";
    };

    inherit meta;
  };



  python-package = buildPythonPackage rec {
    inherit pname version;
    format = "other";

    src = bazel-build;

    inherit meta;
  };

in python-package
