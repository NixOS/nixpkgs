{ stdenv
, buildPythonPackage
, fetchPypi
, robotframework
, selenium
, docutils
, decorator
}:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "robotframework-selenium2library";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a8e942b0788b16ded253039008b34d2b46199283461b294f0f41a579c70fda7";
  };

  # error: invalid command 'test'
  #doCheck = false;

  propagatedBuildInputs = [ robotframework selenium docutils decorator ];

  meta = with stdenv.lib; {
    description = "Web testing library for Robot Framework";
    homepage = http://robotframework.org/;
    license = licenses.asl20;
  };

}
