{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "keepalive";
  version = "0.5";
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

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "An HTTP handler for `urllib` that supports HTTP 1.1 and keepalive";
    homepage = "https://github.com/wikier/keepalive";
    license = licenses.lgpl21Plus;
  };
}
