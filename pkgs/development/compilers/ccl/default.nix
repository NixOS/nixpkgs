{
  lib,
  stdenv,
  fetchurl,
  bootstrap_cmds,
  coreutils,
  glibc,
  m4,
  runtimeShell,
}:

let
  options = rec {
    # TODO: there are also FreeBSD and Windows versions
    x86_64-linux = {
      arch = "linuxx86";
      hash = "sha256-lv/2fFO1bcZ6zAbpL/F3S3NAFWRlBmnJXnxj8SAKT10=";
      runtime = "lx86cl64";
      kernel = "linuxx8664";
      faslExt = "lx64fsl";
    };
    i686-linux = {
      arch = "linuxx86";
      hash = x86_64-linux.hash;
      runtime = "lx86cl";
      kernel = "linuxx8632";
      faslExt = "lx32fsl";
    };
    armv7l-linux = {
      arch = "linuxarm";
      hash = "sha256-W9vbUwFHmcDmFZLU8/diJPcESqvPgU3ilNW+SrYRpN0=";
      runtime = "armcl";
      kernel = "linuxarm";
      faslExt = "lafsl";
    };
    armv6l-linux = armv7l-linux;
    aarch64-linux = {
      arch = "linuxarm64";
      hash = "sha256-dmxO9jcI6pFS9FZetZ2Jp5qz3a+FKmnA75FjP4n2EzI=";
      runtime = "arm64cl";
      kernel = "linuxarm64";
      faslExt = "la64fsl";
    };
    aarch64-darwin = {
      arch = "darwinarm64";
      hash = "sha256-wm2HkFPGaRGC2nec7q23/U4tY9BKSmA8//Wi8SS+AhE=";
      runtime = "darm64cl";
      kernel = "darwinarm64";
      faslExt = "da64fsl";
    };
  };
  cfg =
    options.${stdenv.hostPlatform.system}
      or (throw "missing source url for platform ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation (finalAttrs: {
  pname = "ccl";
  version = "1.14";

  src = fetchurl {
    url = "https://github.com/Clozure/ccl/releases/download/v${finalAttrs.version}/ccl-${finalAttrs.version}-${cfg.arch}.tar.gz";
    hash = cfg.hash;
  };

  nativeBuildInputs = [ m4 ] ++ lib.optional stdenv.hostPlatform.isDarwin bootstrap_cmds;

  buildInputs = lib.optional stdenv.hostPlatform.isLinux glibc;

  env = {
    CCL_RUNTIME = cfg.runtime;
    CCL_KERNEL = cfg.kernel;
  };

  postPatch = ''
    substituteInPlace lisp-kernel/${finalAttrs.env.CCL_KERNEL}/Makefile \
      --replace-fail "/bin/rm" "${coreutils}/bin/rm" \
      --replace-quiet "/bin/echo" "${coreutils}/bin/echo"

    substituteInPlace lisp-kernel/m4macros.m4 \
      --replace-fail "/bin/pwd" "${coreutils}/bin/pwd"
  '';

  buildPhase = ''
    make -C lisp-kernel/${finalAttrs.env.CCL_KERNEL} clean
    make -C lisp-kernel/${finalAttrs.env.CCL_KERNEL} all

    ./${finalAttrs.env.CCL_RUNTIME} -n -b -e '(ccl:rebuild-ccl :full t)' -e '(ccl:quit)'
  '';

  installPhase = ''
    mkdir -p "$out/share"
    cp -r .  "$out/share/ccl-installation"

    mkdir -p "$out/bin"
    echo -e '#!${runtimeShell}\n'"$out/share/ccl-installation/${finalAttrs.env.CCL_RUNTIME}"' "$@"\n' > "$out"/bin/"${finalAttrs.env.CCL_RUNTIME}"
    chmod a+x "$out"/bin/"${finalAttrs.env.CCL_RUNTIME}"
    ln -s "$out"/bin/"${finalAttrs.env.CCL_RUNTIME}" "$out"/bin/ccl
  '';

  hardeningDisable = [ "format" ];

  passthru = {
    inherit (cfg) faslExt;
  };

  meta = {
    description = "Clozure Common Lisp";
    homepage = "https://ccl.clozure.com/";
    license = lib.licenses.asl20;
    mainProgram = "ccl";
    teams = [ lib.teams.lisp ];
    platforms = lib.attrNames options;
  };
})
