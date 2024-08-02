{
  stdenv,
  buildPythonPackage,
  lib,
  fetchPypi,
  patchelf
}:

buildPythonPackage rec {
  pname = "casadi";
  version = "3.6.5";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;

    platform = "manylinux2014_x86_64";
    python = "cp312";
    dist = "cp312";

    hash = "sha256-ARhjeCPikqknATPgLJxtPzx/dejJGm9txSda3oLdHZ0=";
  };

  postInstall = ''
    ${patchelf}/bin/patchelf --add-needed    \
      ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 \
      $out/lib/python3.12/site-packages/casadi/_casadi.so
  '';

  meta = {
    description = "Symbolic framework for nonlinear optimization and algorithmic differentiation";
    homepage = "https://web.casadi.org";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = [ "x86_64-linux" ];
  };
}
