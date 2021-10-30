{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, python3
}:

stdenv.mkDerivation rec {
  pname = "libvarlink";
  version = "22";

  src = fetchFromGitHub {
    owner = "varlink";
    repo = pname;
    rev = version;
    sha256 = "1i15227vlc9k4276r833ndhxrcys9305pf6dga1j0alx2vj85yz2";
  };

  nativeBuildInputs = [ meson ninja ];

  postPatch = ''
    substituteInPlace varlink-wrapper.py \
      --replace "/usr/bin/env python3" "${python3}/bin/python3"

    # test-object: ../lib/test-object.c:129: main: Assertion `setlocale(LC_NUMERIC, "de_DE.UTF-8") != 0' failed.
    # PR that added it https://github.com/varlink/libvarlink/pull/27
    substituteInPlace lib/test-object.c \
      --replace 'assert(setlocale(LC_NUMERIC, "de_DE.UTF-8") != 0);' ""

    patchShebangs lib/test-symbols.sh
  '';

  doCheck = true;

  meta = with lib; {
    description = "C implementation of the Varlink protocol and command line tool";
    homepage = "https://github.com/varlink/libvarlink";
    license = licenses.asl20;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
  };
}
