{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, cppunit
}:

stdenv.mkDerivation rec {
  pname = "cpp-utilities";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cghk1a0ki1063ci63imakmggwzkky1hx6lhrvc0wjfv754wsklb";
  };
  # See https://github.com/Martchus/cpp-utilities/issues/18
  patches = [
    (fetchpatch {
      url = "https://github.com/Martchus/cpp-utilities/commit/b2a2773cdfb2b0017a3fa3d0ed2259a9a5fda666.patch";
      sha256 = "01js90ba4xxljifncm48zbxmg7mwwz1gla1hn87yzbic47d85hfj";
    })
    (fetchpatch {
      url = "https://github.com/Martchus/cpp-utilities/commit/4dd2179f191d1ace113f26177944684fa1561dc1.patch";
      sha256 = "0chw33mwsvj7cigd1c4xl2zhpbfsp5rrijdm46qpn78bq70xcz9j";
    })
  ];

  nativeBuildInputs = [ cmake ];
  checkInputs = [ cppunit ];
  # Otherwise, tests fail since the resulting shared object libc++utilities.so is only available in PWD of the make files
  checkFlagsArray = [ "LD_LIBRARY_PATH=$(PWD)" ];
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
