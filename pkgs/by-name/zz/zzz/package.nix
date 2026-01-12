{
  asciidoctor,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "zzz";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "zzz";
    tag = "v${version}";
    hash = "sha256-gm/fzhgGM2kns051PKY223uesctvMj9LmLc4btUsTt8=";
  };

  postPatch = ''
    substituteInPlace zzz.c --replace-fail \
      'setenv("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", 1);' 'setenv("PATH", "/run/wrappers/bin:/run/current-system/sw/bin", 1);'
  '';

  nativeBuildInputs = [ asciidoctor ];

  makeFlags = [
    "prefix=$(out)"
    "sysconfdir=$(out)/etc"
  ];

  meta = {
    description = "Simple program to suspend or hibernate your computer";
    mainProgram = "zzz";
    homepage = "https://github.com/jirutka/zzz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aanderse ];
    platforms = lib.platforms.linux;
  };
}
