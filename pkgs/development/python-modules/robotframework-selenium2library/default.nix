{ stdenv, buildPythonPackage, fetchPypi, robotframework-seleniumlibrary }:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "robotframework-selenium2library";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a8e942b0788b16ded253039008b34d2b46199283461b294f0f41a579c70fda7";
  };

  # Neither the PyPI tarball nor the repository has tests
  doCheck = false;

  propagatedBuildInputs = [ robotframework-seleniumlibrary ];

  meta = with stdenv.lib; {
    description = "Web testing library for Robot Framework";
    homepage = https://github.com/robotframework/Selenium2Library;
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };

}
