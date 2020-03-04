{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, mozfile
, mozhttpd
, wptserve
}:

buildPythonPackage rec {
  pname = "mozprofile";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09l18x72vahq7il9nj6qj7la2d21vvbcn9szlm3vsvsbkz68w0yk";
  };

  propagatedBuildInputs = [ mozlog mozfile mozhttpd ];

  checkInputs = [ wptserve ];

  meta = {
    description = "Mozilla application profile handling library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
