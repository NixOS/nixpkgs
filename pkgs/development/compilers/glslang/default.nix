{ stdenv
, fetchFromGitHub
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
# https://github.com/KhronosGroup/glslang/blob/${version}/known_good.json

let
  localSpirv-tools = if argSpirv-tools == null
    then spirv-tools.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Tools";
        rev = "b27b1afd12d05bf238ac7368bb49de73cd620a8e";
        sha256 = "0v26ws6qx23jn4dcpsq6rqmdxgyxpl5pcvfm90wb3nz6iqbqx294";
      };
    })
    else argSpirv-tools;

  localSpirv-headers = if argSpirv-headers == null
    then spirv-headers.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Headers";
        rev = "f027d53ded7e230e008d37c8b47ede7cd308e19d";
        sha256 = "12gp2mqcar6jj57jw9isfr62yn72kmvdcl0zga4gvrlyfhnf582q";
      };
    })
    else argSpirv-headers;
in

stdenv.mkDerivation rec {
  pname = "glslang";
  version = "11.1.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = version;
    sha256 = "1j81pghy7whyr8ygk7lx6g6qph61rky7fkkc8xp87c7n695a48rw";
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
    platforms = platforms.unix;
    maintainers = [ maintainers.ralith ];
  };
}
