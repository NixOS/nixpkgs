{ stdenv, fetchFromGitLab, icmake
, libmilter, libX11, openssl, readline
, utillinux, yodl }:

stdenv.mkDerivation rec {
  pname = "bobcat";
  version = "5.05.00";

  src = fetchFromGitLab {
    sha256 = "sha256:14lvxzkxmkk54s97ah996m6s1wbw1g3iwawbhsf8qw7sf75vlp1h";
    domain = "gitlab.com";
    rev = version;
    repo = "bobcat";
    owner = "fbb-git";
  };

  buildInputs = [ libmilter libX11 openssl readline utillinux ];
  nativeBuildInputs = [ icmake yodl ];

  setSourceRoot = ''
    sourceRoot=$(echo */bobcat)
  '';

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs .
  '';

  buildPhase = ''
    ./build libraries all
    ./build man
  '';

  installPhase = ''
    ./build install x
  '';

  meta = with stdenv.lib; {
    description = "Brokken's Own Base Classes And Templates";
    homepage = "https://fbb-git.gitlab.io/bobcat/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
