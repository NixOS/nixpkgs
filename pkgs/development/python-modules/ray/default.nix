{ stdenv
, lib
, fetchurl
, buildPythonPackage
, mock
, fetchPypi
, wheel
, python
, symlinkJoin
}:


buildPythonPackage {
  pname = "ray";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pzgj85c6g8vr3dq215cd1y2pn8pxc6wa7mjd9m0zrglr1qwwhdz";
  };

  postFixup =
    let
      # rpaths we only need to add if CUDA is enabled.

      libpaths = [
        stdenv.cc.cc.lib
        zlib
      ];

      rpath = stdenv.lib.makeLibraryPath (libpaths);
    in
      lib.optionalString stdenv.isLinux ''
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./_build/pip_packages/lib/python3.7/site-packages/ray/core/src/ray/thirdparty/redis/src/redis-server
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./_build/pip_packages/lib/python3.7/site-packages/ray/core/src/ray/gcs/gcs_server
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./_build/pip_packages/lib/python3.7/site-packages/ray/core/src/ray/raylet/raylet
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./_build/pip_packages/lib/python3.7/site-packages/ray/core/src/ray/raylet/raylet_monitor
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./_build/pip_packages/lib/python3.7/site-packages/ray/core/src/plasma/plasma_store_server
      '';


  pythonImportsCheck = [
    "ray"
  ];

  meta = with stdenv.lib; {
    description = "A system for parallel and distributed Python that unifies "
      "the ML ecosystem.";
    homepage = https://ray.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ mjlbach ];
    platforms = [ "x86_64-linux" ];
    broken = stdenv.isDarwin;
  };
}
