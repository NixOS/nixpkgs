{ mkDerivation, lib, fetchFromGitLab, doxygen, glib, libaccounts-glib, pkg-config, qmake }:

mkDerivation rec {
  pname = "accounts-qt";
  version = "1.16";

  src = fetchFromGitLab {
    sha256 = "1vmpjvysm0ld8dqnx8msa15hlhrkny02cqycsh4k2azrnijg0xjz";
    rev = "VERSION_${version}";
    repo = "libaccounts-qt";
    owner = "accounts-sso";
  };

  propagatedBuildInputs = [ glib libaccounts-glib ];
  nativeBuildInputs = [ doxygen pkg-config qmake ];

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with lib; {
    description = "Qt library for accessing the online accounts database";
    homepage = "https://gitlab.com/accounts-sso";
    license = licenses.lgpl21;
    platforms = with platforms; linux;
  };
}
