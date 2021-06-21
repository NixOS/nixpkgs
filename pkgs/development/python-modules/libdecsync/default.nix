{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "libdecsync";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "IcdOOgkj3sfLuP+pkSEaHmqot+km3wLJNx+H/4ONz+g=";
  };

  meta = with lib; {
    description = "libdecsync is a Python3 wrapper around libdecsync for synchronizing using DecSync";
    homepage = "https://github.com/39aldo39/libdecsync-bindings-python3";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.linux;
  };
}
