{ stdenv, fetchFromGitHub
, bison
, cmake
, jq
, python3
, spirv-headers
, spirv-tools
, argSpirv-tools ? null
, argSpirv-headers ? null
}:
# glslang requires custom versions of spirv-tools and spirb-headers.
# The exact versions are taken from:
# https://github.com/KhronosGroup/glslang/blob/master/known_good.json

let
  localSpirv-tools = if argSpirv-tools == null
    then spirv-tools.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Tools";
        rev = "fd8e130510a6b002b28eee5885a9505040a9bdc9";
        sha256 = "00b7xgyrcb2qq63pp3cnw5q1xqx2d9rfn65lai6n6r89s1vh3vg6";
      };
    })
    else argSpirv-tools;

  localSpirv-headers = if argSpirv-headers == null
    then spirv-headers.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Headers";
        rev = "f8bf11a0253a32375c32cad92c841237b96696c0";
        sha256 = "1znwjy02dl9rshqzl87rqsv9mfczw7gvwfhcirbl81idahgp4p6l";
      };
    })
    else argSpirv-headers;
in

stdenv.mkDerivation rec {
  pname = "glslang";
  version = "8.13.3743";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = version;
    sha256 = "0d20wfpp2fmbnz1hnsjr9xc62lxpj86ik2qyviqbni0pqj212cry";
  };

  # These get set at all-packages, keep onto them for child drvs
  passthru = {
    spirv-tools = localSpirv-tools;
    spirv-headers = localSpirv-headers;
  };

  nativeBuildInputs = [ cmake python3 bison jq ];
  enableParallelBuilding = true;

  postPatch = ''
    cp --no-preserve=mode -r "${localSpirv-tools.src}" External/spirv-tools
    ln -s "${localSpirv-headers.src}" External/spirv-tools/external/spirv-headers
  '';

  # Ensure spirv-headers and spirv-tools match exactly to what is expected
  preConfigure = ''
    HEADERS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools/external/spirv-headers"))[0].commit')
    TOOLS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools"))[0].commit')
    if [ "$HEADERS_COMMIT" != "${localSpirv-headers.src.rev}" ] || [ "$TOOLS_COMMIT" != "${localSpirv-tools.src.rev}" ]; then
      echo "ERROR: spirv-tools commits do not match expected versions: expected tools at $TOOLS_COMMIT, headers at $HEADERS_COMMIT";
      exit 1;
    fi
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
