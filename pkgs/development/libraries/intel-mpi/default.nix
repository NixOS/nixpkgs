{ lib
, stdenvNoCC
, callPackage
, fetchurl
, rpmextract
}:
let
  version = "2021.8.0";
  rel = "25329";
  oneapi-mpi = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mpi-${version}-${version}-${rel}.x86_64.rpm";
    sha256 = "sha256-6RPaGXKPa3InyFar4dypV0lhkpzL/2NDXyXeGFkNQvE=";
  };
  oneapi-mpi-devel = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mpi-devel-${version}-${version}-${rel}.x86_64.rpm";
    sha256 = "sha256-e4Kx1EUzZ5B9tac/TWzJf0qUA++TpdntM+H/4UAL4VQ=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "intel-mpi";
  inherit version;
  dontUnpack = true;  # unpack using rpmextract
  # do not modify the binary per license agreement
  dontStrip = true;
  dontPatchELF = true;

  nativeBuildInputs = [ rpmextract ];

  buildPhase = ''
    rpmextract ${oneapi-mpi}
    rpmextract ${oneapi-mpi-devel}
  '';

  installPhase = ''
    # hardcode MPI root paths for any scripts (non-binary-files found via grep)
    for f in $(find opt/intel/oneapi/mpi/${version}/bin -type f -exec grep -Il . "{}" \; ) ; do
      substituteInPlace $f \
        --replace $\{I_MPI_ROOT} "$out" \
        --replace '$I_MPI_ROOT' "$out"
    done

    # License
    install -Dm0655 -t $out/share/doc/mpi opt/intel/oneapi/mpi/${version}/licensing/*.txt

    # Binaries
    # mkdir -p $out/bin
    cp -r opt/intel/oneapi/mpi/${version}/bin $out
    rm $out/bin/impi_info

    # Libraries (dynamic + static)
    # mkdir -p $out/lib
    cp -a opt/intel/oneapi/mpi/${version}/lib $out/

    # Headers
    cp -r opt/intel/oneapi/mpi/${version}/include $out/

    # CMake Config: none found?

    # TODO: include man files?
    # echo "TODO: finish implementation" && exit 1
  '';

  passthru.tests = {
    pkg-config = callPackage ./test.nix {intel-mpi-devel-src = oneapi-mpi-devel;};
  };

  meta = with lib; {
    description = "Intel OneAPI Message Passing Interface (MPI) Library";
    longDescription = ''
      Intel® MPI Library is a multifabric message-passing library that implements
      the open source MPICH specification. Use the library to create, maintain,
      and test advanced, complex applications that perform better on HPC clusters
      based on Intel® and compatible processors.
    '';
    homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.issl;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ drewrisinger ];
  };
}
