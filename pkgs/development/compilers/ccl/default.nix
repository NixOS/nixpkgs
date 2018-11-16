{ stdenv, fetchurl, bootstrap_cmds, coreutils, glibc, m4 }:

let
  options = rec {
    /* TODO: there are also FreeBSD and Windows versions */
    x86_64-linux = {
      arch = "linuxx86";
      sha256 = "0hs1f3z7crgzvinpj990kv9gvbsipxvcvwbmk54n51nasvc5025q";
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
      sha256 = "0p0l1dzsygb6i1xxgbipjpxkn46xhq3jm41a34ga1qqp4x8lkr62";
      runtime = "armcl";
      kernel = "linuxarm";
    };
    x86_64-darwin = {
      arch = "darwinx86";
      sha256 = "5adbea3d8b4a2e29af30d141f781c6613844f468c0ccfa11bae908c3e9641939";
      runtime = "dx86cl64";
      kernel = "darwinx8664";
    };
    armv6l-linux = armv7l-linux;
  };
  cfg = options."${stdenv.hostPlatform.system}" or (throw "missing source url for platform ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation rec {
  name     = "ccl-${version}";
  version  = "1.11.5";

  src = fetchurl {
    url = "https://github.com/Clozure/ccl/releases/download/v${version}/ccl-${version}-${cfg.arch}.tar.gz";
    sha256 = cfg.sha256;
  };

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
    echo -e '#!${stdenv.shell}\n'"$out/share/ccl-installation/${CCL_RUNTIME}"' "$@"\n' > "$out"/bin/"${CCL_RUNTIME}"
    chmod a+x "$out"/bin/"${CCL_RUNTIME}"
    ln -s "$out"/bin/"${CCL_RUNTIME}" "$out"/bin/ccl
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Clozure Common Lisp";
    homepage    = https://ccl.clozure.com/;
    maintainers = with maintainers; [ raskin muflax tohl ];
    platforms   = attrNames options;
    license     = licenses.lgpl21;
  };
}
