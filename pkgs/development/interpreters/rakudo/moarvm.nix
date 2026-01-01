{
<<<<<<< HEAD
  fetchFromGitHub,
  lib,
  perl,
  pkg-config,
  stdenv,
  versionCheckHook,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moarvm";
  version = "2025.12";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "MoarVM";
    repo = "MoarVM";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-hftskJ+5p/XHahAJTG28ifWkExb8Z8u7J5CeoQooUYE=";
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
=======
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "moarvm";
  version = "2025.06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "moarvm";
    repo = "moarvm";
    rev = version;
    hash = "sha256-QtJ8cLAbsFJ26wkfQCbIMVU1ArWlAXjsQ/RJbQ0wRNo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs .
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Configure.pl \
      --replace '`/usr/bin/arch`' '"${stdenv.hostPlatform.darwinArch}"' \
      --replace '/usr/bin/arch' "$(type -P true)" \
      --replace '/usr/' '/nope/'
    substituteInPlace 3rdparty/dyncall/configure \
      --replace '`sw_vers -productVersion`' '"11.0"'
  '';

  buildInputs = [ perl ];
  doCheck = false; # MoarVM does not come with its own test suite

  configureScript = "${perl}/bin/perl ./Configure.pl";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
