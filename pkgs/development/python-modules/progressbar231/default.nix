{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "progressbar231";
  version = "2.3.1";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j0ifxk87xz3wkyacxaiqygghn27wwz6y5pj9k8j2yq7n33fbdam";
  };

  # no tests implemented
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/progressbar231;
    description = "Text progressbar library for python";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ twey ];
  };
}
