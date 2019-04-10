{ stdenv
, lib
, python
, buildPythonPackage
, fetchPypi
, radare2
, coreutils
}:

buildPythonPackage rec {
  pname = "r2pipe";
  version = "1.2.0";

  postPatch = let
    r2lib = "${lib.getOutput "lib" radare2}/lib";
    libr_core = "${r2lib}/libr_core${stdenv.hostPlatform.extensions.sharedLibrary}";
  in
  ''
    # Fix find_library, can be removed after
    # https://github.com/NixOS/nixpkgs/issues/7307 is resolved.
    substituteInPlace r2pipe/native.py --replace "find_library('r_core')" "'${libr_core}'"

    # Fix the default r2 executable
    substituteInPlace r2pipe/open_sync.py --replace "r2e = 'radare2'" "r2e = '${radare2}/bin/radare2'"
    substituteInPlace r2pipe/open_base.py --replace 'which("radare2")' "'${radare2}/bin/radare2'"
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qs3xqmi9alahsgr8akzw06ia4c3554dz8pran1h7z5llk262nj4";
  };

  # Tiny sanity check to make sure r2pipe finds radare2 (since r2pipe doesn't
  # provide its own tests):
  # Analyze ls with the fastest analysis and do nothing with the result.
  postCheck = ''
    ${python.interpreter} <<EOF
    import r2pipe
    r2 = r2pipe.open('${coreutils}/bin/ls')
    r2.cmd('a')
    r2.quit()
    EOF
  '';

  meta = with stdenv.lib; {
    description = "Interact with radare2";
    homepage = https://github.com/radare/radare2-r2pipe;
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
