{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, cmake, sip }:

buildPythonPackage rec {
  pname = "libsavitar";
  version = "4.0.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libSavitar";
    rev = version;
    sha256 = "1q70l37qafzfkpw8vlagmpd2w576b6jc1xmxp3wf3qfq45j8kya0";
  };

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ sip ];

  disabled = pythonOlder "3.4.0";

  meta = with stdenv.lib; {
    description = "C++ implementation of 3mf loading with SIP python bindings";
    homepage = https://github.com/Ultimaker/libSavitar;
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar orivej ];
  };
}
