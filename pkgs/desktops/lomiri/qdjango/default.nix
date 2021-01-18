{ mkDerivation, lib, fetchFromGitHub
, qmake, doxygen
, qtbase
}:

mkDerivation rec {
  pname = "qdjango-unstable";
  version = "2018-03-07";

  src = fetchFromGitHub {
    owner = "jlaine";
    repo = "qdjango";
    rev = "bda4755ece9d173a67b880e498027fcdc51598a8";
    sha256 = "0jf2ycp17j22pbwykl4746znhwc9xwi0937j6bavvgr5q9zd3iz4";
  };

  postPatch = ''
    substituteInPlace qdjango.pro \
      --replace 'dist.depends = docs' 'htmldocs.depends = docs'
  '';

  nativeBuildInputs = [ qmake doxygen ];

  buildInputs = [ qtbase ];

  postConfigure = ''
    # This project provides Qt Tests (testlib, testcase) and wants to install them to qtbase's directory
    # Force recursive Makefile creation, manually patch qtbase paths
    make qmake_all
    for makeFile in $(find tests -name Makefile); do
      echo $makeFile
      substituteInPlace $makeFile \
        --replace '$(INSTALL_ROOT)${qtbase.dev}/tests/' '$(INSTALL_ROOT)${placeholder "out"}/tests/'
    done
  '';

  postInstall = ''
    # These don't seem to be required to be installed in the first place, and they cause /build reference problems
    rm -rf $out/tests
  '';

  meta = with lib; {
    description = "A Qt-based C++ web framework";
    homepage = "https://github.com/jlaine/qdjango/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
