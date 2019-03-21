{ lib, fetchPypi, buildPythonPackage, astroid, six, coverage
, lazy-object-proxy, nose, wrapt
}:

buildPythonPackage rec {
  pname = "asttokens";
  version = "1.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vd4djlxmgznz84gzakkv45avnrcpgl1kir92l1pxyp0z5c0dh2m";
  };

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
