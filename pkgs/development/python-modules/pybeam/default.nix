{ buildPythonPackage
, construct
, fetchFromGitHub
, lib
, six
}:

buildPythonPackage rec {
  pname = "pybeam";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "matwey";
    repo = pname;
    rev = version;
    hash = "sha256-Wmo4RlHpzVsmytidF9/YIeSlWy0P3zkG28ZUp9w5ieQ=";
  };

  propagatedBuildInputs = [
    construct
    six
  ];

  meta = with lib; {
    # metadata from https://rpmfind.net/linux/RPM/fedora/devel/rawhide/x86_64/r/rpmlint-2.4.0-4.fc38.noarch.html
    description = "Python module to parse Erlang BEAM files";
    homepage = "https://github.com/matwey/pybeam";
    downloadPage = "https://github.com/matwey/pybeam/releases";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
}
