{ lib, stdenv, fetchurl, fetchpatch, runCommand, bootstrap_cmds, coreutils, glibc, m4, runtimeShell }:

let
  options = rec {
    /* TODO: there are also FreeBSD and Windows versions */
    x86_64-linux = {
      arch = "linuxx86";
      sha256 = "0d5bsizgpw9hv0jfsf4bp5sf6kxh8f9hgzz9hsjzpfhs3npmmac4";
      runtime = "lx86cl64";
      kernel = "linuxx8664";
    };
    i686-linux = {
      arch = "linuxx86";
      sha256 = x86_64-linux.sha256;
      runtime = "lx86cl";
      kernel = "linuxx8632";
    };
    armv7l-linux = {
      arch = "linuxarm";
      sha256 = throw "ccl all-in-one linuxarm archive missing upstream";
      runtime = "armcl";
      kernel = "linuxarm";
    };
    x86_64-darwin = {
      arch = "darwinx86";
      sha256 = "1l060719k8mjd70lfdnr0hkybk7v88zxvfrsp7ww50q808cjffqk";
      runtime = "dx86cl64";
      kernel = "darwinx8664";
    };
    armv6l-linux = armv7l-linux;
  };
  cfg = options.${stdenv.hostPlatform.system} or (throw "missing source url for platform ${stdenv.hostPlatform.system}");

  # The 1.12 github release of CCL seems to be missing the usual
  # ccl-1.12-linuxarm.tar.gz tarball, so we build it ourselves here
  linuxarm-src = runCommand "ccl-1.12-linuxarm.tar.gz" {
    outer = fetchurl {
      url = "https://github.com/Clozure/ccl/archive/v1.12.tar.gz";
      sha256 = "0lmxhll6zgni0l41h4kcf3khbih9r0f8xni6zcfvbi3dzfs0cjkp";
    };
    inner = fetchurl {
      url = "https://github.com/Clozure/ccl/releases/download/v1.12/linuxarm.tar.gz";
      sha256 = "0x4bjx6cxsjvxyagijhlvmc7jkyxifdvz5q5zvz37028va65243c";
    };
  } ''
    tar xf $outer
    tar xf $inner -C ccl
    tar czf $out ccl
  '';

in

stdenv.mkDerivation rec {
  pname = "ccl";
  version  = "1.12";

  src = if cfg.arch == "linuxarm" then linuxarm-src else fetchurl {
    url = "https://github.com/Clozure/ccl/releases/download/v${version}/ccl-${version}-${cfg.arch}.tar.gz";
    sha256 = cfg.sha256;
  };

  patches = [
    # Pull upstream fiux for -fno-common toolchains:
    #  https://github.com/Clozure/ccl/pull/316
    (fetchpatch {
      name = "fno-common-p1.patch";
      url = "https://github.com/Clozure/ccl/commit/185dc1a00e7492f8be98e5f93b561758423595f1.patch";
      sha256 = "0wqfds7346qdwdsxz3bl2p601ib94rdp9nknj7igj01q8lqfpajw";
    })
    (fetchpatch {
      name = "fno-common-p2.patch";
      url = "https://github.com/Clozure/ccl/commit/997de91062d1f152d0c3b322a1e3694243e4a403.patch";
      sha256 = "10w6zw8wgalkdyya4m48lgca4p9wgcp1h44hy9wqr94dzlllq0f6";
    })
  ];

  buildInputs = if stdenv.isDarwin then [ bootstrap_cmds m4 ] else [ glibc m4 ];

  CCL_RUNTIME = cfg.runtime;
  CCL_KERNEL = cfg.kernel;

  postPatch = if stdenv.isDarwin then ''
    substituteInPlace lisp-kernel/${CCL_KERNEL}/Makefile \
      --replace "M4 = gm4"   "M4 = m4" \
      --replace "dtrace"     "/usr/sbin/dtrace" \
      --replace "/bin/rm"    "${coreutils}/bin/rm" \
      --replace "/bin/echo"  "${coreutils}/bin/echo"

    substituteInPlace lisp-kernel/m4macros.m4 \
      --replace "/bin/pwd" "${coreutils}/bin/pwd"
  '' else ''
    substituteInPlace lisp-kernel/${CCL_KERNEL}/Makefile \
      --replace "/bin/rm"    "${coreutils}/bin/rm" \
      --replace "/bin/echo"  "${coreutils}/bin/echo"

    substituteInPlace lisp-kernel/m4macros.m4 \
      --replace "/bin/pwd" "${coreutils}/bin/pwd"
  '';

  buildPhase = ''
    make -C lisp-kernel/${CCL_KERNEL} clean
    make -C lisp-kernel/${CCL_KERNEL} all

    ./${CCL_RUNTIME} -n -b -e '(ccl:rebuild-ccl :full t)' -e '(ccl:quit)'
  '';

  installPhase = ''
    mkdir -p "$out/share"
    cp -r .  "$out/share/ccl-installation"

    mkdir -p "$out/bin"
    echo -e '#!${runtimeShell}\n'"$out/share/ccl-installation/${CCL_RUNTIME}"' "$@"\n' > "$out"/bin/"${CCL_RUNTIME}"
    chmod a+x "$out"/bin/"${CCL_RUNTIME}"
    ln -s "$out"/bin/"${CCL_RUNTIME}" "$out"/bin/ccl
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Clozure Common Lisp";
    homepage    = "https://ccl.clozure.com/";
    maintainers = lib.teams.lisp.members;
    platforms   = attrNames options;
    # assembler failures during build, x86_64-darwin broken since 2020-10-14
    broken      = (stdenv.isDarwin && stdenv.isx86_64);
    license     = licenses.asl20;
  };
}
