{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "keepalive";
  version = "0.5";
<<<<<<< HEAD
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PGuW+QYqWnYCLwydQenvVVLYCxyt1PzMG/jxg7odHsE=";
  };

  patches = [
    # https://github.com/wikier/keepalive/pull/11
    (fetchpatch {
      name = "remove-use_2to3.patch";
      url = "https://github.com/wikier/keepalive/commit/64393f6c5bf9c69d946b584fd664dd4df72604e6.patch";
      hash = "sha256-/G1eEt8a4Qz7x5oQnDZZD/PIQwo9+oPZoy9OrXGHvR4=";
      excludes = ["README.md"];
    })
  ];

=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c6b96f9062a5a76022f0c9d41e9ef5552d80b1cadd4fccc1bf8f183ba1d1ec1";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # No tests included
  doCheck = false;

  meta = with lib; {
<<<<<<< HEAD
    description = "An HTTP handler for `urllib` that supports HTTP 1.1 and keepalive";
    homepage = "https://github.com/wikier/keepalive";
    license = licenses.lgpl21Plus;
  };
=======
    description = "An HTTP handler for `urllib2` that supports HTTP 1.1 and keepalive";
    homepage = "https://github.com/wikier/keepalive";
    license = licenses.asl20;
    broken = true; # uses use_2to3, which is no longer supported for setuptools>=58
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
