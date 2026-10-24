{
  lib,
  patchelf,
  stdenv,
  package,
  headers,
  libraries,
  symbols,
  driverLibraries ? [ ],
}:
stdenv.mkDerivation {
  name = "${package.name}-public-headers";
  strictDeps = true;
  # The package must supply its public dependencies through ordinary input
  # propagation, without NVCC or additional toolkit inputs masking omissions.
  buildInputs = [ package ];
  nativeBuildInputs = lib.optional (driverLibraries != [ ]) patchelf;
  buildCommand = ''
    cat > consumer.cpp <<'CPP'
    ${lib.concatMapStringsSep "\n" (header: "#include <${header}>") headers}
    ${lib.concatImapStringsSep "\n" (
      i: symbol: "auto * volatile symbol${toString i} = &${symbol};"
    ) symbols}
    int main() {
      return ${lib.concatImapStringsSep " || " (i: _: "symbol${toString i} == nullptr") symbols};
    }
    CPP
    ${lib.optionalString (driverLibraries != [ ]) ''
      # Resolve hardware-provided DT_NEEDED entries only while linking. Keeping
      # these outside buildInputs also preserves the isolated header check.
      mkdir driver-stubs
      for library in ${lib.escapeShellArgs driverLibraries}; do
        ln -s "$library" "driver-stubs/$(patchelf --print-soname "$library")"
      done
    ''}
    mkdir -p "$out/bin"
    "$CXX" -std=c++17 consumer.cpp ${lib.concatMapStringsSep " " (library: "-l${library}") libraries} \
      ${lib.optionalString (driverLibraries != [ ]) ''-Wl,-rpath-link,"$PWD/driver-stubs"''} \
      -o "$out/bin/consumer"
    ${lib.optionalString (driverLibraries != [ ]) ''
      case "$(patchelf --print-rpath "$out/bin/consumer")" in
        *"$PWD"*|*/lib/stubs*)
          echo "Link-time driver stubs leaked into consumer RUNPATH" >&2
          exit 1
          ;;
      esac
    ''}
    cp consumer.cpp "$out/"
  '';
}
