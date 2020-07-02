{ stdenv, buildPythonPackage, fetchPypi, docutils }:

buildPythonPackage rec {
  pname = "collective.checkdocs";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vp4amk5cj1x244mxfhxphvb6zqdj61c281qfmrbq92jghjjhlrs";
    extension = "zip";
  };

  propagatedBuildInputs = [ docutils ];

  meta = with stdenv.lib; {
    description = "Distutils command to view and validate restructured text in package's long_description";
    homepage = "https://github.com/collective/collective.checkdocs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fadenb ];
  };
}
