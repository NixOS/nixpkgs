{ stdenv, fetchFromGitHub, fetchpatch, cmake, bison, spirv-tools, jq }:

stdenv.mkDerivation rec {
  name = "glslang-git-${version}";
  version = "2018-07-27";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "e99a26810f65314183163c07664a40e05647c15f";
    sha256 = "1w11z518xfbnf34xgzg1mp3xicpw2qmpcvaixlzw79s9ifqg5lqs";
  };

  patches = [
    # spirv-tools bump for vulkan sdk 1.1.82.1; remove on update
    (fetchpatch {
      url = "https://github.com/lenny-lunarg/glslang/commit/c7f4e818ac55f545289f87f8c37571b2eadcde86.patch";
      sha256 = "197293alxjdpm3x1vd6pksdb1d9za42vlyn8yn2w786av0l7vf1k";
    })
  ];

  buildInputs = [ cmake bison jq ] ++ spirv-tools.buildInputs;
  enableParallelBuilding = true;

  postPatch = ''
    cp --no-preserve=mode -r "${spirv-tools.src}" External/spirv-tools
    ln -s "${spirv-tools.headers}" External/spirv-tools/external/spirv-headers
  '';

  preConfigure = ''
    HEADERS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools/external/spirv-headers"))[0].commit')
    TOOLS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools"))[0].commit')
    if [ "$HEADERS_COMMIT" != "${spirv-tools.headers.rev}" ] || [ "$TOOLS_COMMIT" != "${spirv-tools.src.rev}" ]; then
      echo "ERROR: spirv-tools commits do not match expected versions: expected tools at $TOOLS_COMMIT, headers at $HEADERS_COMMIT";
      exit 1;
    fi
  '';

  doCheck = false; # fails 3 out of 3 tests (ctest)

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
