{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libspf2";
  version = "2.2.13";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "libspf2";
    rev = "v${version}";
    hash = "sha256-tkCHP3B1sBb0+scHBjX5lCvaeSrZryfaGKye02LFlYs=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  strictDeps = true;

  postPatch = ''
    # disable static bins compilation
    sed -i \
      -e '/bin_PROGRAMS/s/spfquery_static//' src/spfquery/Makefile.am \
      -e '/bin_PROGRAMS/s/spftest_static//' src/spftest/Makefile.am \
      -e '/bin_PROGRAMS/s/spfd_static//' src/spfd/Makefile.am \
      -e '/bin_PROGRAMS/s/spf_example_static//' src/spf_example/Makefile.am
  '';

  doCheck = true;

  meta = with lib; {
    description =
      "Implementation of the Sender Policy Framework for SMTP " + "authorization (Helsinki Systems fork)";
    homepage = "https://github.com/helsinki-systems/libspf2";
    license = with licenses; [
      lgpl21Plus
      bsd2
    ];
    maintainers = with maintainers; [ pacien ] ++ teams.helsinki-systems.members;
    platforms = platforms.all;
  };
}
