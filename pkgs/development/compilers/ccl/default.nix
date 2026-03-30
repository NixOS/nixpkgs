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
      hash = "sha256-cAae50xvBoXfg+tiJM4i8+eRnheyM0dseE5EDWDia/E=";
      runtime = "lx86cl64";
      kernel = "linuxx8664";
    };
    i686-linux = {
      arch = "linuxx86";
      hash = x86_64-linux.hash;
      runtime = "lx86cl";
      kernel = "linuxx8632";
    };
    armv7l-linux = {
      arch = "linuxarm";
      hash = "sha256-iyUMTDuHbyfEAxAAhjXANjh6HhpLkWG5+diXI6aFUUc=";
      runtime = "armcl";
      kernel = "linuxarm";
    };
    x86_64-darwin = {
      arch = "darwinx86";
      hash = "sha256-r+OhkU0b+QDgoZpZb0Xpc3V0yRq8GBKcNLt2IzeOSdE=";
      runtime = "dx86cl64";
      kernel = "darwinx8664";
    };
    armv6l-linux = armv7l-linux;
  };
  cfg =
    options.${stdenv.hostPlatform.system}
      or (throw "missing source url for platform ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation (finalAttrs: {
  pname = "ccl";
  version = "1.13";

  src = fetchurl {
    url = "https://github.com/Clozure/ccl/releases/download/v${finalAttrs.version}/ccl-${finalAttrs.version}-${cfg.arch}.tar.gz";
    hash = cfg.hash;
  };

  buildInputs =
    if stdenv.hostPlatform.isDarwin then
      [
        bootstrap_cmds
        m4
      ]
    else
      [
        glibc
        m4
      ];

  env = {
    CCL_RUNTIME = cfg.runtime;
    CCL_KERNEL = cfg.kernel;
  };

  postPatch =
    if stdenv.hostPlatform.isDarwin then
      ''
        substituteInPlace lisp-kernel/${finalAttrs.env.CCL_KERNEL}/Makefile \
          --replace "M4 = gm4"   "M4 = m4" \
          --replace "dtrace"     "/usr/sbin/dtrace" \
          --replace "/bin/rm"    "${coreutils}/bin/rm" \
          --replace "/bin/echo"  "${coreutils}/bin/echo"

        substituteInPlace lisp-kernel/m4macros.m4 \
          --replace "/bin/pwd" "${coreutils}/bin/pwd"
      ''
    else
      ''
        substituteInPlace lisp-kernel/${finalAttrs.env.CCL_KERNEL}/Makefile \
          --replace "/bin/rm"    "${coreutils}/bin/rm" \
          --replace "/bin/echo"  "${coreutils}/bin/echo"

        substituteInPlace lisp-kernel/m4macros.m4 \
          --replace "/bin/pwd" "${coreutils}/bin/pwd"
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

  meta = {
    # assembler failures during build, x86_64-darwin broken since 2020-10-14
    broken = (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);
    description = "Clozure Common Lisp";
    homepage = "https://ccl.clozure.com/";
    license = lib.licenses.asl20;
    mainProgram = "ccl";
    teams = [ lib.teams.lisp ];
    platforms = lib.attrNames options;
  };
})
