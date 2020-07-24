{ stdenv, buildPythonPackage, fetchPypi, pam }:

buildPythonPackage rec {
  pname = "python-pam";
  version = "1.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16whhc0vr7gxsbzvsnq65nq8fs3wwmx755cavm8kkczdkz4djmn8";
  };

  postPatch = ''
    substituteInPlace pam.py --replace 'find_library("pam")' \
      '"${pam}/lib/libpam${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  meta = with stdenv.lib; {
    description = "Python PAM module using ctypes";
    homepage = "https://github.com/FirefighterBlu3/python-pam";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.mit;
  };
}
