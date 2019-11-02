{ lib, fetchPypi, buildPythonPackage, fetchpatch, astroid, six, coverage
, lazy-object-proxy, nose, wrapt
}:

buildPythonPackage rec {
  pname = "asttokens";
  version = "1.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vd4djlxmgznz84gzakkv45avnrcpgl1kir92l1pxyp0z5c0dh2m";
  };

  patches = [
    # Fix tests for astroid 2.2 in python 3. Remove with the next release
    (fetchpatch {
      url = "https://github.com/gristlabs/asttokens/commit/21caaaa74105c410b3d84c3d8ff0dc2f612aac9a.patch";
      sha256 = "182xfr0cx4pxx0dv1l50a1c281h8ywir8vvd1zh5iicflivim1nv";
    })
  ];

  propagatedBuildInputs = [ lazy-object-proxy six wrapt astroid ];

  checkInputs = [ coverage nose ];

  meta = with lib; {
    homepage = https://github.com/gristlabs/asttokens;
    description = "Annotate Python AST trees with source text and token information";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
  };
}
