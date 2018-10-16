{ stdenv
, buildPythonPackage
, fetchPypi
, docutils
, lxml
, manuel
, pygments
, svg-path
, watchdog
, isPy3k
}:

buildPythonPackage rec {
  pname = "hovercraft";
  version = "2.0";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lqxr816lymgnywln8bbv9nrmkyahjjcjkm9kjyny9bflayz4f1g";
  };

  propagatedBuildInputs = [ docutils lxml manuel pygments svg-path watchdog ];

  # one test assumes we have docutils 0.12
  # TODO: enable tests after upgrading docutils to 0.12
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A tool to make impress.js presentations from reStructuredText";
    homepage = https://github.com/regebro/hovercraft;
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };

}
