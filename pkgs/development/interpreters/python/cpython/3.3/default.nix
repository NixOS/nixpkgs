{ stdenv, fetchurl
, bzip2
, gdbm
, lzma
, ncurses
, openssl
, readline
, sqlite
, tcl ? null, tk ? null, libX11 ? null, xproto ? null, x11Support ? false
, zlib
, callPackage
, self
, python33Packages
, CF, configd
}:

assert x11Support -> tcl != null
                  && tk != null
                  && xproto != null
                  && libX11 != null;

with stdenv.lib;

let
  majorVersion = "3.3";
  minorVersion = "6";
  minorVersionSuffix = "";
  pythonVersion = majorVersion;
  version = "${majorVersion}.${minorVersion}${minorVersionSuffix}";
  libPrefix = "python${majorVersion}";
  sitePackages = "lib/${libPrefix}/site-packages";

  buildInputs = filter (p: p != null) [
    zlib bzip2 lzma gdbm sqlite readline ncurses openssl ]
    ++ optionals x11Support [ tcl tk libX11 xproto ]
    ++ optionals stdenv.isDarwin [ CF configd ];

in stdenv.mkDerivation {
  name = "python3-${version}";
  pythonVersion = majorVersion;
  inherit majorVersion version;

  inherit buildInputs;

  src = fetchurl {
    url = "https://www.python.org/ftp/python/${majorVersion}.${minorVersion}/Python-${version}.tar.xz";
    sha256 = "0gsxpgd5p4mwd01gw501vsyahncyw3h9836ypkr3y32kgazy89jj";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString stdenv.isDarwin ''export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"''}

    configureFlagsArray=( --enable-shared --with-threads
                          CPPFLAGS="${concatStringsSep " " (map (p: "-I${getDev p}/include") buildInputs)}"
                          LDFLAGS="${concatStringsSep " " (map (p: "-L${getLib p}/lib") buildInputs)}"
                          LIBS="${optionalString (!stdenv.isDarwin) "-lcrypt"} ${optionalString (ncurses != null) "-lncurses"}"
                        )
  '';

  setupHook = ./setup-hook.sh;

  postInstall = ''
    # needed for some packages, especially packages that backport functionality
    # to 2.x from 3.x
    for item in $out/lib/python${majorVersion}/test/*; do
      if [[ "$item" != */test_support.py* ]]; then
        rm -rf "$item"
      else
        echo $item
      fi
    done
    touch $out/lib/python${majorVersion}/test/__init__.py
    ln -s "$out/include/python${majorVersion}m" "$out/include/python${majorVersion}"
    paxmark E $out/bin/python${majorVersion}

    # Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
    echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py

    # Use Python3 as default python
    ln -s "$out/bin/idle3" "$out/bin/idle"
    ln -s "$out/bin/pip3" "$out/bin/pip"
    ln -s "$out/bin/pydoc3" "$out/bin/pydoc"
    ln -s "$out/bin/python3" "$out/bin/python"
    ln -s "$out/bin/python3-config" "$out/bin/python-config"
  '';

  postFixup = ''
    # Get rid of retained dependencies on -dev packages, and remove
    # some $TMPDIR references to improve binary reproducibility.
    for i in $out/lib/python${majorVersion}/_sysconfigdata.py $out/lib/python${majorVersion}/config-${majorVersion}m/Makefile; do
      sed -i $i -e "s|-I/nix/store/[^ ']*||g" -e "s|-L/nix/store/[^ ']*||g" -e "s|$TMPDIR|/no-such-path|g"
    done

    # FIXME: should regenerate this.
    rm $out/lib/python${majorVersion}/__pycache__/_sysconfigdata.cpython*

  '';

  passthru = rec {
    inherit libPrefix sitePackages x11Support;
    executable = "${libPrefix}m";
    buildEnv = callPackage ../../wrapper.nix { python = self; };
    withPackages = import ../../with-packages.nix { inherit buildEnv; pythonPackages = python33Packages; };
    isPy3 = true;
    isPy33 = true;
    is_py3k = true;  # deprecated
    interpreter = "${self}/bin/${executable}";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = http://python.org;
    description = "A high-level dynamically-typed programming language";
    longDescription = ''
      Python is a remarkably powerful dynamic programming language that
      is used in a wide variety of application domains. Some of its key
      distinguishing features include: clear, readable syntax; strong
      introspection capabilities; intuitive object orientation; natural
      expression of procedural code; full modularity, supporting
      hierarchical packages; exception-based error handling; and very
      high level dynamic data types.
    '';
    license = stdenv.lib.licenses.psfl;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ chaoflow cstrahan ];
  };
}
