{
  fetchFromGitHub,
  lib,
  perl,
  pkg-config,
  stdenv,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moarvm";
  version = "2025.10";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "MoarVM";
    repo = "MoarVM";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-ZTQsjEHBAhmUdEJAKz/mt+DHcSwlY41jIMtJ2vFNNqY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zstd ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Configure.pl \
      --replace-fail 'my @check_tools = qw/ar cc ld/;' 'my @check_tools = ();'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Configure.pl \
      --replace-fail '`/usr/bin/arch`' '"${stdenv.hostPlatform.darwinArch}"' \
      --replace-fail '/usr/bin/arch' "$(type -P true)" \
      --replace-fail '/usr/' '/nope/'
    substituteInPlace 3rdparty/dyncall/configure \
      --replace-fail '`sw_vers -productVersion`' '"11.0"'
  '';

  configureScript = "${lib.getExe perl} ./Configure.pl";
  configureFlags = [
    "--pkgconfig=${lib.getExe pkg-config}"
  ];

  meta = {
    description = "VM with adaptive optimization and JIT compilation, built for Rakudo";
    homepage = "https://moarvm.org";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [
      thoughtpolice
      sgo
      prince213
    ];
    mainProgram = "moar";
    platforms = lib.platforms.unix;
  };
})
