{ stdenv
, buildPythonPackage
, fetchPypi
, prompt_toolkit
, pygments
, robotframework
}:
buildPythonPackage rec {
  version = "1.2";
  pname = "robotframework-debuglibrary";
  src = fetchPypi {
    inherit pname version;
    sha256 = "a464f1241d8ea113468119936789ffaf6b49714769fd5f3dde236de2ddee208c";
  };
  # unit tests are impure
  doCheck = false;
  propagatedBuildInputs = [
    prompt_toolkit
    pygments
    robotframework
  ];
  meta = with stdenv.lib; {
    description = "Robotframework-DebugLibrary is a debug library for RobotFramework";
    homepage = https://github.com/xyb/robotframework-debuglibrary/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ talkara ];
  };
}
