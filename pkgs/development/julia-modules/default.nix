{ pkgs
, lib
, fetchurl
, juliaPkgs
, computeRequiredJuliaPackages
, computeJuliaDepotPath
, computeJuliaLoadPath
, computeJuliaArtifacts
}:

with juliaPkgs;

[

  {
    pname = "FFMPEG";
    version = "0.4.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/c87230d0-a227-11e9-1b43-d7ebe4e7570a/b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8";
      name = "julia-bin-1.8.3-FFMPEG-0.4.1.tar.gz";
      sha256 = "e3c13cd62b476d4638b9271332ccca903deb829576d8ac6f9cee3dc6209318d6";
    };
    requiredJuliaPackages = [ FFMPEG_jll ];
  }

  {
    pname = "Wayland_protocols_jll";
    version = "1.25.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/2381bf8a-dfd0-557d-9999-79630e7b1b91/4528479aa01ee1b3b4cd0e6faef0e04cf16466da";
      name = "julia-bin-1.8.3-Wayland_protocols_jll-1.25.0+0.tar.gz";
      sha256 = "7e6133000253b9066311b5ce98a0f3decc8c97e2ab1c9dc2f6ef81c6b33f4c6a";
    };
    requiredJuliaPackages = [ Wayland_protocols_jll-Wayland_protocols JLLWrappers ];
  }

  {
    pname = "Wayland_protocols_jll-Wayland_protocols";
    version = "1.25.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Wayland_protocols_jll.jl/releases/download/Wayland_protocols-v1.25.0+0/Wayland_protocols.v1.25.0.any.tar.gz";
      name = "julia-bin-1.8.3-Wayland_protocols_jll-Wayland_protocols-1.25.0+0.tar.gz";
      sha256 = "d1a84e0016d12f933a2ef390a0fa7db442df631c6c42a433c2b1c207f89f92f5";
    };
    isJuliaArtifact = true;
    juliaPath = "f42f9d226c70f0bc88e5f897d914d9de1ac2ce03";
  }

  {
    pname = "Xorg_xcb_util_renderutil_jll";
    version = "0.3.9+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/0d47668e-0667-5a69-a72c-f761630bfb7e/dfd7a8f38d4613b6a575253b3174dd991ca6183e";
      name = "julia-bin-1.8.3-Xorg_xcb_util_renderutil_jll-0.3.9+1.tar.gz";
      sha256 = "22da963a00938e6c5d4f5c80b1472f4b3f2e7588fbf40f6ea594530e9319fe88";
    };
    requiredJuliaPackages = [ Xorg_xcb_util_renderutil_jll-Xorg_xcb_util_renderutil JLLWrappers Xorg_xcb_util_jll ];
  }

  {
    pname = "Xorg_xcb_util_renderutil_jll-Xorg_xcb_util_renderutil";
    version = "0.3.9+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_xcb_util_renderutil_jll.jl/releases/download/Xorg_xcb_util_renderutil-v0.3.9+1/Xorg_xcb_util_renderutil.v0.3.9.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_xcb_util_renderutil_jll-Xorg_xcb_util_renderutil-0.3.9+1.tar.gz";
      sha256 = "c5ee27039ff7d8b1d1b87537019294f066cbd7c7ce10eaac05a5a34c810aaa02";
    };
    isJuliaArtifact = true;
    juliaPath = "1a2adcee7d99fea18ead33c350332626b262e29a";
  }

  {
    pname = "Scratch";
    version = "1.1.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/6c6a2e73-6563-6170-7368-637461726353/f94f779c94e58bf9ea243e77a37e16d9de9126bd";
      name = "julia-bin-1.8.3-Scratch-1.1.1.tar.gz";
      sha256 = "04bdfbd7c1b39398c56d4679eb9748a175d46432b6242e72836a10f5684eb9cb";
    };

  }

  {
    pname = "ColorTypes";
    version = "0.11.4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/3da002f7-5984-5a60-b8a6-cbb66c0b333f/eb7f0f8307f71fac7c606984ea5fb2817275d6e4";
      name = "julia-bin-1.8.3-ColorTypes-0.11.4.tar.gz";
      sha256 = "c9814b302c7a1f0aa048c16fdae0f4699277d67a6fad72765cb7c723252ccfb9";
    };
    requiredJuliaPackages = [ FixedPointNumbers ];
  }

  {
    pname = "JpegTurbo_jll";
    version = "2.1.2+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/aacddb02-875f-59d6-b918-886e6ef4fbf8/b53380851c6e6664204efb2e62cd24fa5c47e4ba";
      name = "julia-bin-1.8.3-JpegTurbo_jll-2.1.2+0.tar.gz";
      sha256 = "082f100ff9ec1dfd144cfc182dd0511ba750dc031aaeb89196b0ba0c7edaa42c";
    };
    requiredJuliaPackages = [ JpegTurbo_jll-JpegTurbo JLLWrappers ];
  }

  {
    pname = "JpegTurbo_jll-JpegTurbo";
    version = "2.1.2+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/JpegTurbo_jll.jl/releases/download/JpegTurbo-v2.1.2+0/JpegTurbo.v2.1.2.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-JpegTurbo_jll-JpegTurbo-2.1.2+0.tar.gz";
      sha256 = "b0165d5627f929dc8254d3d73341b6a6b9ad1f73c825e24437f82fdd0241b9ab";
    };
    isJuliaArtifact = true;
    juliaPath = "8793267ae1f4b96f626caa27147aa0218389c30d";
  }

  {
    pname = "IrrationalConstants";
    version = "0.1.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/92d709cd-6900-40b7-9082-c6be49f344b6/7fd44fd4ff43fc60815f8e764c0f352b83c49151";
      name = "julia-bin-1.8.3-IrrationalConstants-0.1.1.tar.gz";
      sha256 = "8f8e79fe3fdcb9b17461ccd9ec87b5a64e4d97c9ef4995c3f0b92697cd17f928";
    };

  }

  {
    pname = "x265_jll";
    version = "3.5.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/dfaa095f-4041-5dcd-9319-2fabd8486b76/ee567a171cce03570d77ad3a43e90218e38937a9";
      name = "julia-bin-1.8.3-x265_jll-3.5.0+0.tar.gz";
      sha256 = "1d0576f631acbe9acac59f6d58e61f8e6d0d8147989ce6df978554b83db694ce";
    };
    requiredJuliaPackages = [ x265_jll-x265 JLLWrappers ];
  }

  {
    pname = "x265_jll-x265";
    version = "3.5.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/x265_jll.jl/releases/download/x265-v3.5.0+0/x265.v3.5.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-x265_jll-x265-3.5.0+0.tar.gz";
      sha256 = "c13c7606c7fc319913e3bf516c6c49af23a2dd37e8acdacf33978828d2c0de03";
    };
    isJuliaArtifact = true;
    juliaPath = "fc239b3ff5739aeab252bd154fa4dd045fefe629";
  }

  {
    pname = "Showoff";
    version = "1.0.3";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/992d4aef-0814-514b-bc4d-f2e9a6c4116f/91eddf657aca81df9ae6ceb20b959ae5653ad1de";
      name = "julia-bin-1.8.3-Showoff-1.0.3.tar.gz";
      sha256 = "8a6dd1233f30ab71dc04598f06c3732a34cb985ce7cb86ac2e17235895b00675";
    };
    requiredJuliaPackages = [ Grisu ];
  }

  {
    pname = "Plots";
    version = "1.38.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/91a5bcdd-55d7-5caf-9e0b-520d859cae80/513084afca53c9af3491c94224997768b9af37e8";
      name = "julia-bin-1.8.3-Plots-1.38.0.tar.gz";
      sha256 = "a3a059e071bef8960aa786c77e0b303b5144295f21e4e5181f87879719848b55";
    };
    requiredJuliaPackages = [ Showoff GR FixedPointNumbers JLFzf Unzip RecipesPipeline LaTeXStrings PlotUtils SnoopPrecompile JSON StatsBase RelocatableFolders Scratch Latexify Preferences FFMPEG Measures RecipesBase UnicodeFun PlotThemes Contour Reexport Requires NaNMath ];
  }

  {
    pname = "libfdk_aac_jll";
    version = "2.0.2+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/f638f0a6-7fb0-5443-88ba-1cc74229b280/daacc84a041563f965be61859a36e17c4e4fcd55";
      name = "julia-bin-1.8.3-libfdk_aac_jll-2.0.2+0.tar.gz";
      sha256 = "5f8b4205b93021abbe1a47559ae77d00381145d38c08555d75e362a576c87266";
    };
    requiredJuliaPackages = [ libfdk_aac_jll-libfdk_aac JLLWrappers ];
  }

  {
    pname = "libfdk_aac_jll-libfdk_aac";
    version = "2.0.2+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/libfdk_aac_jll.jl/releases/download/libfdk_aac-v2.0.2+0/libfdk_aac.v2.0.2.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-libfdk_aac_jll-libfdk_aac-2.0.2+0.tar.gz";
      sha256 = "7180dacdb5abb7103331f9fec4b0fe0d1a67857075a3680898ac9f8e75895617";
    };
    isJuliaArtifact = true;
    juliaPath = "cc415631aeb190b075329ce756f690a90e1f873b";
  }

  {
    pname = "Graphite2_jll";
    version = "1.3.14+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/3b182d85-2403-5c21-9c21-1e1f0cc25472/344bf40dcab1073aca04aa0df4fb092f920e4011";
      name = "julia-bin-1.8.3-Graphite2_jll-1.3.14+0.tar.gz";
      sha256 = "d77d43daa270150a19dd5b3b99eb408765c8282434f22cecf0cffdbc61d145a6";
    };
    requiredJuliaPackages = [ Graphite2_jll-Graphite2 JLLWrappers ];
  }

  {
    pname = "Graphite2_jll-Graphite2";
    version = "1.3.14+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Graphite2_jll.jl/releases/download/Graphite2-v1.3.14+0/Graphite2.v1.3.14.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Graphite2_jll-Graphite2-1.3.14+0.tar.gz";
      sha256 = "16b4532bdb986aabf57d044c576d959dd05eb938a5b8b4e63c25dbdd7b0be55e";
    };
    isJuliaArtifact = true;
    juliaPath = "62c010876222f83fe8878bf2af0e362083d20ee3";
  }

  {
    pname = "GR_jll";
    version = "0.71.2+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d2c73de3-f751-5644-a686-071e5b155ba9/64ef06fa8f814ff0d09ac31454f784c488e22b29";
      name = "julia-bin-1.8.3-GR_jll-0.71.2+0.tar.gz";
      sha256 = "18ce23ccabd71f7e95d08d00cbee6ff7f924a1fd38fd6152f9787b8916430bf0";
    };
    requiredJuliaPackages = [ GR_jll-GR Fontconfig_jll Pixman_jll FFMPEG_jll JpegTurbo_jll Qt5Base_jll Cairo_jll Libtiff_jll GLFW_jll JLLWrappers Bzip2_jll libpng_jll ];
  }

  {
    pname = "GR_jll-GR";
    version = "0.71.2+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/GR_jll.jl/releases/download/GR-v0.71.2+0/GR.v0.71.2.x86_64-linux-gnu-cxx11.tar.gz";
      name = "julia-bin-1.8.3-GR_jll-GR-0.71.2+0.tar.gz";
      sha256 = "6e777b3e0973a444a3835e5b83faa45889b17f2c74b53bf68a22da2298f41b09";
    };
    isJuliaArtifact = true;
    juliaPath = "72345d29248fca1d7bb7cf948aca75230e57484a";
  }

  {
    pname = "libass_jll";
    version = "0.15.1+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/0ac62f75-1d6f-5e53-bd7c-93b484bb37c0/5982a94fcba20f02f42ace44b9894ee2b140fe47";
      name = "julia-bin-1.8.3-libass_jll-0.15.1+0.tar.gz";
      sha256 = "41bddf6ef23a51c0a0009f7bb79f6876a53f9024c2358346b31412c91d8602e4";
    };
    requiredJuliaPackages = [ libass_jll-libass JLLWrappers Bzip2_jll FreeType2_jll HarfBuzz_jll FriBidi_jll ];
  }

  {
    pname = "libass_jll-libass";
    version = "0.15.1+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/libass_jll.jl/releases/download/libass-v0.15.1+0/libass.v0.15.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-libass_jll-libass-0.15.1+0.tar.gz";
      sha256 = "c7e44a4873ee15ce74a0c01452f8e9d0891cddd07a839630c337a4183a889bb5";
    };
    isJuliaArtifact = true;
    juliaPath = "459252c01ffcd08700841efdd4b6d3edfe5916e7";
  }

  {
    pname = "XML2_jll";
    version = "2.10.3+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a/93c41695bc1c08c46c5899f4fe06d6ead504bb73";
      name = "julia-bin-1.8.3-XML2_jll-2.10.3+0.tar.gz";
      sha256 = "46205de4d767d08bc4f85eef262a4bba145b0d86b121695060f199b5119c7672";
    };
    requiredJuliaPackages = [ XML2_jll-XML2 JLLWrappers Libiconv_jll ];
  }

  {
    pname = "XML2_jll-XML2";
    version = "2.10.3+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/XML2_jll.jl/releases/download/XML2-v2.10.3+0/XML2.v2.10.3.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-XML2_jll-XML2-2.10.3+0.tar.gz";
      sha256 = "b86a438f9e9a549de362e1b206653d76ba0109445f8dae539441bb1727409438";
    };
    isJuliaArtifact = true;
    juliaPath = "f792596249694cc12db3689d386d3a6c5d24e794";
  }

  {
    pname = "Pixman_jll";
    version = "0.40.1+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/30392449-352a-5448-841d-b1acce4e97dc/b4f5d02549a10e20780a24fce72bea96b6329e29";
      name = "julia-bin-1.8.3-Pixman_jll-0.40.1+0.tar.gz";
      sha256 = "e6de6995281e0cf462290879e4c09f0db15ca031772987d3aa0c29a5408ed063";
    };
    requiredJuliaPackages = [ Pixman_jll-Pixman JLLWrappers ];
  }

  {
    pname = "Pixman_jll-Pixman";
    version = "0.40.1+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Pixman_jll.jl/releases/download/Pixman-v0.40.1+0/Pixman.v0.40.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Pixman_jll-Pixman-0.40.1+0.tar.gz";
      sha256 = "6801be29d1a591c96af5f4bf53a3d06ca2a777a21661f704936a66a26f219bfc";
    };
    isJuliaArtifact = true;
    juliaPath = "f3337de0321b3370b90643d18bf63bd4ee79c991";
  }

  {
    pname = "Libmount_jll";
    version = "2.35.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/4b2f31a3-9ecc-558c-b454-b3730dcb73e9/9c30530bf0effd46e15e0fdcf2b8636e78cbbd73";
      name = "julia-bin-1.8.3-Libmount_jll-2.35.0+0.tar.gz";
      sha256 = "c80953feb62a004cc6a87b1be8ac7733948868d146854e5d6c58bb63f4eb5a09";
    };
    requiredJuliaPackages = [ Libmount_jll-Libmount JLLWrappers ];
  }

  {
    pname = "Libmount_jll-Libmount";
    version = "2.35.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Libmount_jll.jl/releases/download/Libmount-v2.35.0+0/Libmount.v2.35.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Libmount_jll-Libmount-2.35.0+0.tar.gz";
      sha256 = "1db5da71d47f0284a7ad7fe3eb0faf481649e89015a9d5c31da340e9170b1b0d";
    };
    isJuliaArtifact = true;
    juliaPath = "5a508a62784097dab7c7ae5805f2c89d2cc97397";
  }

  {
    pname = "Xorg_libXext_jll";
    version = "1.3.4+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/1082639a-0dae-5f34-9b06-72781eeb8cb3/b7c0aa8c376b31e4852b360222848637f481f8c3";
      name = "julia-bin-1.8.3-Xorg_libXext_jll-1.3.4+4.tar.gz";
      sha256 = "b18902c561e33ac61d044b5ac7617f5f58261345b14e9d5456506f0cef6b3037";
    };
    requiredJuliaPackages = [ Xorg_libXext_jll-Xorg_libXext JLLWrappers Xorg_libX11_jll ];
  }

  {
    pname = "Xorg_libXext_jll-Xorg_libXext";
    version = "1.3.4+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXext_jll.jl/releases/download/Xorg_libXext-v1.3.4+3/Xorg_libXext.v1.3.4.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXext_jll-Xorg_libXext-1.3.4+4.tar.gz";
      sha256 = "ad0719c30cc8d8a7339a52deb85114e5067b1443b4f20a6d37f8b7b47b8fd941";
    };
    isJuliaArtifact = true;
    juliaPath = "fc6071b99b67da0ae4e49ebab70c369ce9a76c9e";
  }

  {
    pname = "JSON";
    version = "0.21.3";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/682c06a0-de6a-54ab-a142-c8b1cf79cde6/3c837543ddb02250ef42f4738347454f95079d4e";
      name = "julia-bin-1.8.3-JSON-0.21.3.tar.gz";
      sha256 = "b4460b9387d322538fc68f2e63a858a62a7af96a44e4a7d650073d5ea93c2977";
    };
    requiredJuliaPackages = [ Parsers ];
  }

  {
    pname = "LERC_jll";
    version = "3.0.0+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/88015f11-f218-50d7-93a8-a6af411a945d/bf36f528eec6634efc60d7ec062008f171071434";
      name = "julia-bin-1.8.3-LERC_jll-3.0.0+1.tar.gz";
      sha256 = "1eb83e55152d8d71394c7f20a6c496d279526ab45405d8b5a416be0a60a3264f";
    };
    requiredJuliaPackages = [ LERC_jll-LERC JLLWrappers ];
  }

  {
    pname = "LERC_jll-LERC";
    version = "3.0.0+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/LERC_jll.jl/releases/download/LERC-v3.0.0+1/LERC.v3.0.0.x86_64-linux-gnu-cxx11.tar.gz";
      name = "julia-bin-1.8.3-LERC_jll-LERC-3.0.0+1.tar.gz";
      sha256 = "f2587cecbe5bd776d606e4bd0071a409a4fff3f380b99983e9493ca5a469ca69";
    };
    isJuliaArtifact = true;
    juliaPath = "694cae97bb3cbf8f1f73f2ecabd891602ccf1751";
  }

  {
    pname = "Latexify";
    version = "0.15.17";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/23fbe1c1-3f47-55db-b15f-69d7ec21a316/ab9aa169d2160129beb241cb2750ca499b4e90e9";
      name = "julia-bin-1.8.3-Latexify-0.15.17.tar.gz";
      sha256 = "dab804bcbf0524dcd57fa474e5c7a21f0c0e0ed35f9764c88dfeef9a0fe57706";
    };
    requiredJuliaPackages = [ OrderedCollections Formatting LaTeXStrings Requires MacroTools ];
  }

  {
    pname = "Gettext_jll";
    version = "0.21.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/78b55507-aeef-58d4-861c-77aaff3498b1/9b02998aba7bf074d14de89f9d37ca24a1a0b046";
      name = "julia-bin-1.8.3-Gettext_jll-0.21.0+0.tar.gz";
      sha256 = "ff242d370a2352679577f9ab7c122f8340ab5715e5fbc2d8bec7edffd5b4fe42";
    };
    requiredJuliaPackages = [ Gettext_jll-Gettext JLLWrappers XML2_jll Libiconv_jll ];
  }

  {
    pname = "Gettext_jll-Gettext";
    version = "0.21.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Gettext_jll.jl/releases/download/Gettext-v0.21.0+0/Gettext.v0.21.0.x86_64-linux-gnu-cxx11.tar.gz";
      name = "julia-bin-1.8.3-Gettext_jll-Gettext-0.21.0+0.tar.gz";
      sha256 = "fe332b26fb1303882a2d3b630048f5901d58510cdc12296eef963976a55b920b";
    };
    isJuliaArtifact = true;
    juliaPath = "dc526f26fb179a3f68eb13fcbe5d2d2a5aa7eeac";
  }

  {
    pname = "Preferences";
    version = "1.3.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/21216c6a-2e73-6563-6e65-726566657250/47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d";
      name = "julia-bin-1.8.3-Preferences-1.3.0.tar.gz";
      sha256 = "9b83524ea9b95060e7d99a4b9133a8015d275f3245e2807da4be9e71f5ebda2c";
    };

  }

  {
    pname = "TensorCore";
    version = "0.1.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/62fd8b95-f654-4bbd-a8a5-9c27f68ccd50/1feb45f88d133a655e001435632f019a9a1bcdb6";
      name = "julia-bin-1.8.3-TensorCore-0.1.1.tar.gz";
      sha256 = "0b7072644504ab7504ad7f7cea01ab130048c85646a082ef2b7a924028fcc2ca";
    };

  }

  {
    pname = "Wayland_jll";
    version = "1.19.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/a2964d1f-97da-50d4-b82a-358c7fce9d89/3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23";
      name = "julia-bin-1.8.3-Wayland_jll-1.19.0+0.tar.gz";
      sha256 = "381486c85386bf7f8907b11cd8850855bbe9ebc4d9e7bc732a4d40254064f2c7";
    };
    requiredJuliaPackages = [ Wayland_jll-Wayland JLLWrappers XML2_jll Expat_jll Libffi_jll ];
  }

  {
    pname = "Wayland_jll-Wayland";
    version = "1.19.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Wayland_jll.jl/releases/download/Wayland-v1.19.0+0/Wayland.v1.19.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Wayland_jll-Wayland-1.19.0+0.tar.gz";
      sha256 = "aa89d78fa2dcd1c46055706848a152a8dab1c703b182a7f5d12290d961646f38";
    };
    isJuliaArtifact = true;
    juliaPath = "3c7eef5f322b19cd4b5db6b21f8cafda87b8b26c";
  }

  {
    pname = "Zstd_jll";
    version = "1.5.2+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/3161d3a3-bdf6-5164-811a-617609db77b4/e45044cd873ded54b6a5bac0eb5c971392cf1927";
      name = "julia-bin-1.8.3-Zstd_jll-1.5.2+0.tar.gz";
      sha256 = "718e863b19f82fc3a7ccc8ad822e1278fb77998c454f67a17a58847f0cf7a2aa";
    };
    requiredJuliaPackages = [ Zstd_jll-Zstd JLLWrappers ];
  }

  {
    pname = "Zstd_jll-Zstd";
    version = "1.5.2+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Zstd_jll.jl/releases/download/Zstd-v1.5.2+0/Zstd.v1.5.2.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Zstd_jll-Zstd-1.5.2+0.tar.gz";
      sha256 = "9d0fff908e3e0273cc8360a3fb4696e4227bc5cd0dd10bd3a4c9d295b9e4e25e";
    };
    isJuliaArtifact = true;
    juliaPath = "d22cde7583df1d5f71160a8e4676955a66a91f33";
  }

  {
    pname = "Qt5Base_jll";
    version = "5.15.3+2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/ea2cea3b-5b76-57ae-a6ef-0a8af62496e1/0c03844e2231e12fda4d0086fd7cbe4098ee8dc5";
      name = "julia-bin-1.8.3-Qt5Base_jll-5.15.3+2.tar.gz";
      sha256 = "4165adc81bba0190a210fdae74843adcc981f45f8f7fc03ef4f233e91290c69c";
    };
    requiredJuliaPackages = [ Qt5Base_jll-Qt5Base Libglvnd_jll Xorg_libxcb_jll Xorg_xcb_util_image_jll xkbcommon_jll Fontconfig_jll JLLWrappers Xorg_xcb_util_wm_jll Glib_jll Xorg_xcb_util_renderutil_jll OpenSSL_jll Xorg_libXext_jll Xorg_xcb_util_keysyms_jll ];
  }

  {
    pname = "Qt5Base_jll-Qt5Base";
    version = "5.15.3+2";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Qt5Base_jll.jl/releases/download/Qt5Base-v5.15.3+2/Qt5Base.v5.15.3.x86_64-linux-gnu-cxx11.tar.gz";
      name = "julia-bin-1.8.3-Qt5Base_jll-Qt5Base-5.15.3+2.tar.gz";
      sha256 = "4a94d0efdd92d63f073a4f7a40cce8e97f0b354d73c894dff7b73f347a9f55db";
    };
    isJuliaArtifact = true;
    juliaPath = "388246ba5e10de0b457ad8a6a855a6603afc7378";
  }

  {
    pname = "LoggingExtras";
    version = "1.0.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/e6f89c97-d47a-5376-807f-9c37f3926c36/cedb76b37bc5a6c702ade66be44f831fa23c681e";
      name = "julia-bin-1.8.3-LoggingExtras-1.0.0.tar.gz";
      sha256 = "12c5b41247f6b003938315e78a9e76ea9c8adbe9638546794291318f54999294";
    };

  }

  {
    pname = "Xorg_xtrans_jll";
    version = "1.4.0+3";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/c5fb5394-a638-5e4d-96e5-b29de1b5cf10/79c31e7844f6ecf779705fbc12146eb190b7d845";
      name = "julia-bin-1.8.3-Xorg_xtrans_jll-1.4.0+3.tar.gz";
      sha256 = "01510ec6314908383dc8fe7095ad78efb350d171017a7c331ee354aed57e652a";
    };
    requiredJuliaPackages = [ Xorg_xtrans_jll-Xorg_xtrans JLLWrappers ];
  }

  {
    pname = "Xorg_xtrans_jll-Xorg_xtrans";
    version = "1.4.0+3";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_xtrans_jll.jl/releases/download/Xorg_xtrans-v1.4.0+2/Xorg_xtrans.v1.4.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_xtrans_jll-Xorg_xtrans-1.4.0+3.tar.gz";
      sha256 = "14a4b2c4afb360c15c49beabe614555af305a5d1d5328f2fb37de22d682ad70e";
    };
    isJuliaArtifact = true;
    juliaPath = "45f6b81caf89f7e08b1253217d7deb82d0af6822";
  }

  {
    pname = "Expat_jll";
    version = "2.4.8+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/2e619515-83b5-522b-bb60-26c02a35a201/bad72f730e9e91c08d9427d5e8db95478a3c323d";
      name = "julia-bin-1.8.3-Expat_jll-2.4.8+0.tar.gz";
      sha256 = "bbccff6090a51865b73c56d7201e0fe18cca827b736ddfd3879cfb08dfac215e";
    };
    requiredJuliaPackages = [ Expat_jll-Expat JLLWrappers ];
  }

  {
    pname = "Expat_jll-Expat";
    version = "2.4.8+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Expat_jll.jl/releases/download/Expat-v2.4.8+0/Expat.v2.4.8.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Expat_jll-Expat-2.4.8+0.tar.gz";
      sha256 = "8acd5348597acf68c3dd8ac07b51a6069828507cfd2e438ee964a2ca777b64ff";
    };
    isJuliaArtifact = true;
    juliaPath = "fac7e6d8fc4c5775bf5118ab494120d2a0db4d64";
  }

  {
    pname = "OpenSSL_jll";
    version = "1.1.19+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/458c3c95-2e84-50aa-8efc-19380b2a3a95/f6e9dba33f9f2c44e08a020b0caf6903be540004";
      name = "julia-bin-1.8.3-OpenSSL_jll-1.1.19+0.tar.gz";
      sha256 = "da6aa869c3dda953da6a81c7750678c3a73e0918aafa95b5feed70afd6b375b0";
    };
    requiredJuliaPackages = [ OpenSSL_jll-OpenSSL JLLWrappers ];
  }

  {
    pname = "OpenSSL_jll-OpenSSL";
    version = "1.1.19+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/OpenSSL_jll.jl/releases/download/OpenSSL-v1.1.19+0/OpenSSL.v1.1.19.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-OpenSSL_jll-OpenSSL-1.1.19+0.tar.gz";
      sha256 = "f479f537c1f41e66876f87476234c549c324b67532dbb4c0316947a1ae35a5d0";
    };
    isJuliaArtifact = true;
    juliaPath = "53037ac9d528ee46c3526799b407ee52b7c224f3";
  }

  {
    pname = "BitFlags";
    version = "0.1.7";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35/43b1a4a8f797c1cddadf60499a8a077d4af2cd2d";
      name = "julia-bin-1.8.3-BitFlags-0.1.7.tar.gz";
      sha256 = "11335b2cacb4469bf60ba191edcd5e2a9d413925b7d24f5ed98c60bb27140bfb";
    };

  }

  {
    pname = "Opus_jll";
    version = "1.3.2+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/91d4177d-7536-5919-b921-800302f37372/51a08fb14ec28da2ec7a927c4337e4332c2a4720";
      name = "julia-bin-1.8.3-Opus_jll-1.3.2+0.tar.gz";
      sha256 = "0c3dee31b84b4d2d9cfb88941627a2ad8ebb4f73e69cc9cd52b3f8cef9023fb6";
    };
    requiredJuliaPackages = [ Opus_jll-Opus JLLWrappers ];
  }

  {
    pname = "Opus_jll-Opus";
    version = "1.3.2+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Opus_jll.jl/releases/download/Opus-v1.3.2+0/Opus.v1.3.2.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Opus_jll-Opus-1.3.2+0.tar.gz";
      sha256 = "d98994f57c751cfc382033e8fbc6545ac72a205577afa43dcc99f2a83402cc4f";
    };
    isJuliaArtifact = true;
    juliaPath = "eff86eedadb59cff1a61399e3242b3f529ca6f59";
  }

  {
    pname = "SpecialFunctions";
    version = "2.1.7";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/276daf66-3868-5448-9aa4-cd146d93841b/d75bda01f8c31ebb72df80a46c88b25d1c79c56d";
      name = "julia-bin-1.8.3-SpecialFunctions-2.1.7.tar.gz";
      sha256 = "49e8326e94e05e108418233b4a64c9f71ef96795e7275afe2e748b3dfe7a50cd";
    };
    requiredJuliaPackages = [ IrrationalConstants ChainRulesCore LogExpFunctions OpenSpecFun_jll ];
  }

  {
    pname = "xkbcommon_jll";
    version = "1.4.1+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d8fb68d0-12a3-5cfd-a85a-d49703b185fd/9ebfc140cc56e8c2156a15ceac2f0302e327ac0a";
      name = "julia-bin-1.8.3-xkbcommon_jll-1.4.1+0.tar.gz";
      sha256 = "cbf7734af0ae9f763718d4a093a9e833277870084481f7c0b4c1d54176baad8f";
    };
    requiredJuliaPackages = [ xkbcommon_jll-xkbcommon JLLWrappers Xorg_libxcb_jll Xorg_xkeyboard_config_jll Wayland_jll Wayland_protocols_jll ];
  }

  {
    pname = "xkbcommon_jll-xkbcommon";
    version = "1.4.1+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/xkbcommon_jll.jl/releases/download/xkbcommon-v1.4.1+0/xkbcommon.v1.4.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-xkbcommon_jll-xkbcommon-1.4.1+0.tar.gz";
      sha256 = "580953526c4e6537e387a75199bc69a397cabe43b69183de791100e2e8d9e95d";
    };
    isJuliaArtifact = true;
    juliaPath = "4443e44120d70a97f8094a67268a886256077e69";
  }

  {
    pname = "Xorg_xcb_util_keysyms_jll";
    version = "0.4.0+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/975044d2-76e6-5fbe-bf08-97ce7c6574c7/d1151e2c45a544f32441a567d1690e701ec89b00";
      name = "julia-bin-1.8.3-Xorg_xcb_util_keysyms_jll-0.4.0+1.tar.gz";
      sha256 = "ad83e916d3594205f8cce93eb2934c21a3f80582084ce178dd8ca87feee5b40d";
    };
    requiredJuliaPackages = [ Xorg_xcb_util_keysyms_jll-Xorg_xcb_util_keysyms JLLWrappers Xorg_xcb_util_jll ];
  }

  {
    pname = "Xorg_xcb_util_keysyms_jll-Xorg_xcb_util_keysyms";
    version = "0.4.0+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_xcb_util_keysyms_jll.jl/releases/download/Xorg_xcb_util_keysyms-v0.4.0+1/Xorg_xcb_util_keysyms.v0.4.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_xcb_util_keysyms_jll-Xorg_xcb_util_keysyms-0.4.0+1.tar.gz";
      sha256 = "2107c88a7ca42b4c8dec4c3d10dbb0d9c8e211a23e9549b6e99c76885ed164a7";
    };
    isJuliaArtifact = true;
    juliaPath = "79cc5446ced978de84b6e673e01da0ebfdd6e4a5";
  }

  {
    pname = "FFMPEG_jll";
    version = "4.4.2+2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/b22a6f82-2f65-5046-a5b2-351ab43fb4e5/74faea50c1d007c85837327f6775bea60b5492dd";
      name = "julia-bin-1.8.3-FFMPEG_jll-4.4.2+2.tar.gz";
      sha256 = "f4a357ad3761f1619c5be9fe55cde4c9fe4a37efbe97e477a3cf3a4559945b27";
    };
    requiredJuliaPackages = [ FFMPEG_jll-FFMPEG LAME_jll Opus_jll FriBidi_jll x264_jll libaom_jll FreeType2_jll libvorbis_jll JLLWrappers x265_jll Bzip2_jll libass_jll libfdk_aac_jll Ogg_jll OpenSSL_jll ];
  }

  {
    pname = "FFMPEG_jll-FFMPEG";
    version = "4.4.2+2";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/FFMPEG_jll.jl/releases/download/FFMPEG-v4.4.2+2/FFMPEG.v4.4.2.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-FFMPEG_jll-FFMPEG-4.4.2+2.tar.gz";
      sha256 = "a8a79f5237d093a8d07cb2a40cbd15c2cfb1310c6c3ae358eb825bb1ec92e0e2";
    };
    isJuliaArtifact = true;
    juliaPath = "b409c0eafb4254a980f9e730f6fbe56867890f6a";
  }

  {
    pname = "ColorSchemes";
    version = "3.20.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/35d6a980-a343-548e-a6ea-1d62b119f2f4/aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3";
      name = "julia-bin-1.8.3-ColorSchemes-3.20.0.tar.gz";
      sha256 = "d866cd3100afdaf82f6d2d592fdcce1e6251e39e6a35ba932db830e69475faae";
    };
    requiredJuliaPackages = [ ColorTypes ColorVectorSpace Colors SnoopPrecompile FixedPointNumbers ];
  }

  {
    pname = "Bzip2_jll";
    version = "1.0.8+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/6e34b625-4abd-537c-b88f-471c36dfa7a0/19a35467a82e236ff51bc17a3a44b69ef35185a2";
      name = "julia-bin-1.8.3-Bzip2_jll-1.0.8+0.tar.gz";
      sha256 = "8dc8168ec6d51a3e46ac394fee2f71ec181c8ac00956d545f9a43f9ecc080888";
    };
    requiredJuliaPackages = [ Bzip2_jll-Bzip2 JLLWrappers ];
  }

  {
    pname = "Bzip2_jll-Bzip2";
    version = "1.0.8+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Bzip2_jll.jl/releases/download/Bzip2-v1.0.8+0/Bzip2.v1.0.8.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Bzip2_jll-Bzip2-1.0.8+0.tar.gz";
      sha256 = "7cac890c49ed760223194100c84c701ecba65fcc2b0a8916950c19143c3bbddb";
    };
    isJuliaArtifact = true;
    juliaPath = "7661e5a9aa217ce3c468389d834a4fb43b0911e8";
  }

  {
    pname = "Pipe";
    version = "1.3.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/b98c9c47-44ae-5843-9183-064241ee97a0/6842804e7867b115ca9de748a0cf6b364523c16d";
      name = "julia-bin-1.8.3-Pipe-1.3.0.tar.gz";
      sha256 = "323b8ece182c7320e36f3693c3e1945fb534298b59738eb22752f26b9b59a9b4";
    };

  }

  {
    pname = "Parsers";
    version = "2.5.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/69de0a69-1ddd-5017-9359-2bf0b02dc9f0/6466e524967496866901a78fca3f2e9ea445a559";
      name = "julia-bin-1.8.3-Parsers-2.5.2.tar.gz";
      sha256 = "14312b64c643ec179cc8bd000ad3d37f543a75f31cdc612301ae0916babdee4a";
    };
    requiredJuliaPackages = [ SnoopPrecompile ];
  }

  {
    pname = "Libgcrypt_jll";
    version = "1.8.7+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d4300ac3-e22c-5743-9152-c294e39db1e4/64613c82a59c120435c067c2b809fc61cf5166ae";
      name = "julia-bin-1.8.3-Libgcrypt_jll-1.8.7+0.tar.gz";
      sha256 = "0ae318c5a6225f538a8cd2e81068bfd0d7f90ab4dfa019c662b55c6fa6059852";
    };
    requiredJuliaPackages = [ Libgcrypt_jll-Libgcrypt JLLWrappers Libgpg_error_jll ];
  }

  {
    pname = "Libgcrypt_jll-Libgcrypt";
    version = "1.8.7+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Libgcrypt_jll.jl/releases/download/Libgcrypt-v1.8.7+0/Libgcrypt.v1.8.7.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Libgcrypt_jll-Libgcrypt-1.8.7+0.tar.gz";
      sha256 = "13850a69474b803d52f949658448aa79afd6c44c231575b2aff7ff52d09160e5";
    };
    isJuliaArtifact = true;
    juliaPath = "92111ef825c608ea220f8e679dd8d908d7ac5b83";
  }

  {
    pname = "SimpleBufferStream";
    version = "1.1.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/777ac1f9-54b0-4bf8-805c-2214025038e7/874e8867b33a00e784c8a7e4b60afe9e037b74e1";
      name = "julia-bin-1.8.3-SimpleBufferStream-1.1.0.tar.gz";
      sha256 = "0701eeaaf00acc0f850180d83bd29744ef87e7939fc05b571b799206d2580f2e";
    };

  }

  {
    pname = "Xorg_xkbcomp_jll";
    version = "1.4.2+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/35661453-b289-5fab-8a00-3d9160c6a3a4/4bcbf660f6c2e714f87e960a171b119d06ee163b";
      name = "julia-bin-1.8.3-Xorg_xkbcomp_jll-1.4.2+4.tar.gz";
      sha256 = "1cc5b33917297ac61a32c956aaa65443cbcb0ae8ba6e9893ddf8c6a885ada45f";
    };
    requiredJuliaPackages = [ Xorg_xkbcomp_jll-Xorg_xkbcomp JLLWrappers Xorg_libxkbfile_jll ];
  }

  {
    pname = "Xorg_xkbcomp_jll-Xorg_xkbcomp";
    version = "1.4.2+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_xkbcomp_jll.jl/releases/download/Xorg_xkbcomp-v1.4.2+3/Xorg_xkbcomp.v1.4.2.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_xkbcomp_jll-Xorg_xkbcomp-1.4.2+4.tar.gz";
      sha256 = "fadda48d06b79e4dfd6f5803e09f42e924e6fef9ceeb250cb4963e300d19969a";
    };
    isJuliaArtifact = true;
    juliaPath = "2022ba6725de1af78cae27ce0d5e8c105e9ed192";
  }

  {
    pname = "RelocatableFolders";
    version = "1.0.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/05181044-ff0b-4ac5-8273-598c1e38db00/90bc7a7c96410424509e4263e277e43250c05691";
      name = "julia-bin-1.8.3-RelocatableFolders-1.0.0.tar.gz";
      sha256 = "4902a2c47defeabf24f925c245abee6f434fa54064ce7abbc2858a0a1553cc2a";
    };
    requiredJuliaPackages = [ Scratch ];
  }

  {
    pname = "GR";
    version = "0.71.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71/bcc737c4c3afc86f3bbc55eb1b9fabcee4ff2d81";
      name = "julia-bin-1.8.3-GR-0.71.2.tar.gz";
      sha256 = "46a54ae89749498e01d8964c0678934fd50decf07842ed9b061f2388868ab038";
    };
    requiredJuliaPackages = [ HTTP JSON Preferences GR_jll ];
  }

  {
    pname = "HarfBuzz_jll";
    version = "2.8.1+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/2e76f6c2-a576-52d4-95c1-20adfe4de566/129acf094d168394e80ee1dc4bc06ec835e510a3";
      name = "julia-bin-1.8.3-HarfBuzz_jll-2.8.1+1.tar.gz";
      sha256 = "2712483763bcc49b2eecce342a362320ea7fac559776eab1875bdc957caff2f9";
    };
    requiredJuliaPackages = [ HarfBuzz_jll-HarfBuzz JLLWrappers Libffi_jll Cairo_jll FreeType2_jll Glib_jll Fontconfig_jll Graphite2_jll ];
  }

  {
    pname = "HarfBuzz_jll-HarfBuzz";
    version = "2.8.1+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/HarfBuzz_jll.jl/releases/download/HarfBuzz-v2.8.1+1/HarfBuzz.v2.8.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-HarfBuzz_jll-HarfBuzz-2.8.1+1.tar.gz";
      sha256 = "94808caccb9ad75549a807ee15d558457e92abd536d9ad1e0ce83a70e5e6674c";
    };
    isJuliaArtifact = true;
    juliaPath = "ee20a84d0166c074dfa736b642902dd87b4da48d";
  }

  {
    pname = "PlotThemes";
    version = "3.1.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/ccf2f8ad-2431-5c83-bf29-c5338b663b6a/1f03a2d339f42dca4a4da149c7e15e9b896ad899";
      name = "julia-bin-1.8.3-PlotThemes-3.1.0.tar.gz";
      sha256 = "27332d0c73b678387540a406380e3f9e4d817f149ff33421ef4c2b30404ab620";
    };
    requiredJuliaPackages = [ PlotUtils ];
  }

  {
    pname = "Contour";
    version = "0.6.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d38c429a-6771-53c6-b99e-75d170b6e991/d05d9e7b7aedff4e5b51a029dced05cfb6125781";
      name = "julia-bin-1.8.3-Contour-0.6.2.tar.gz";
      sha256 = "e9e9157c2f5364dda8580d3a04e6261dd1cf8c67ba498a34fb939de97c0f6259";
    };

  }

  {
    pname = "Xorg_xkeyboard_config_jll";
    version = "2.27.0+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/33bec58e-1273-512f-9401-5d533626f822/5c8424f8a67c3f2209646d4425f3d415fee5931d";
      name = "julia-bin-1.8.3-Xorg_xkeyboard_config_jll-2.27.0+4.tar.gz";
      sha256 = "fc69cad08246944454f1636e1f2c85fb55e6e24ae31ddb18027226fca0ab8093";
    };
    requiredJuliaPackages = [ Xorg_xkeyboard_config_jll-Xorg_xkeyboard_config JLLWrappers Xorg_xkbcomp_jll ];
  }

  {
    pname = "Xorg_xkeyboard_config_jll-Xorg_xkeyboard_config";
    version = "2.27.0+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_xkeyboard_config_jll.jl/releases/download/Xorg_xkeyboard_config-v2.27.0+3/Xorg_xkeyboard_config.v2.27.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_xkeyboard_config_jll-Xorg_xkeyboard_config-2.27.0+4.tar.gz";
      sha256 = "39640762597118365679c1c5a509804cefce0c4d79fa7c0af4f1f2b5e8d0d50a";
    };
    isJuliaArtifact = true;
    juliaPath = "be58fe5ecba3c97f24d6d6d13540b73f19c73e6f";
  }

  {
    pname = "FixedPointNumbers";
    version = "0.8.4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/53c48c17-4a7d-5ca2-90c5-79b7896eea93/335bfdceacc84c5cdf16aadc768aa5ddfc5383cc";
      name = "julia-bin-1.8.3-FixedPointNumbers-0.8.4.tar.gz";
      sha256 = "e6cde9b49ddd755fb679afa722add76e35cd0533fd6300442afdafef172e6cb7";
    };

  }

  {
    pname = "Xorg_libXrandr_jll";
    version = "1.5.2+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/ec84b674-ba8e-5d96-8ba1-2a689ba10484/34cea83cb726fb58f325887bf0612c6b3fb17631";
      name = "julia-bin-1.8.3-Xorg_libXrandr_jll-1.5.2+4.tar.gz";
      sha256 = "8c3f62fd8ee32108c0ebde654ade3b90743cbb8c8577eceb3ba67bc11935e3d2";
    };
    requiredJuliaPackages = [ Xorg_libXrandr_jll-Xorg_libXrandr JLLWrappers Xorg_libXext_jll Xorg_libXrender_jll ];
  }

  {
    pname = "Xorg_libXrandr_jll-Xorg_libXrandr";
    version = "1.5.2+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXrandr_jll.jl/releases/download/Xorg_libXrandr-v1.5.2+3/Xorg_libXrandr.v1.5.2.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXrandr_jll-Xorg_libXrandr-1.5.2+4.tar.gz";
      sha256 = "eb89f0c6d69ad486b5c3197609f57877b58f680a6beb6fd224dba1ecaf405994";
    };
    isJuliaArtifact = true;
    juliaPath = "4daa3879a820580557ef34945e2ae243dfcbba11";
  }

  {
    pname = "DataAPI";
    version = "1.14.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a/e8119c1a33d267e16108be441a287a6981ba1630";
      name = "julia-bin-1.8.3-DataAPI-1.14.0.tar.gz";
      sha256 = "7324c7b366e2e5beb00c75e407fcd63358c65c3b735dbef1b87d530ee7e07c84";
    };

  }

  {
    pname = "Libtiff_jll";
    version = "4.4.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/89763e89-9b03-5906-acba-b20f662cd828/3eb79b0ca5764d4799c06699573fd8f533259713";
      name = "julia-bin-1.8.3-Libtiff_jll-4.4.0+0.tar.gz";
      sha256 = "3b32602ec0549de9c97d08a3a460f6d7737e5d3a52459c4c1a46921a37a239f6";
    };
    requiredJuliaPackages = [ Libtiff_jll-Libtiff JLLWrappers JpegTurbo_jll LERC_jll Zstd_jll ];
  }

  {
    pname = "Libtiff_jll-Libtiff";
    version = "4.4.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Libtiff_jll.jl/releases/download/Libtiff-v4.4.0+0/Libtiff.v4.4.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Libtiff_jll-Libtiff-4.4.0+0.tar.gz";
      sha256 = "5a48156ffff6f8a58e469318d362007225bb74ee8e0f99152b0b8c2a560d0fc7";
    };
    isJuliaArtifact = true;
    juliaPath = "b610fc4e040c9a46c250ea4792cc64098003578a";
  }

  {
    pname = "Measures";
    version = "0.3.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/442fdcdd-2543-5da2-b0f3-8c86c306513e/c13304c81eec1ed3af7fc20e75fb6b26092a1102";
      name = "julia-bin-1.8.3-Measures-0.3.2.tar.gz";
      sha256 = "3586a459ff4347efb12c49942cbb8132314c58a500ec441e9b1c473cbf8981d0";
    };

  }

  {
    pname = "RecipesBase";
    version = "1.3.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/3cdcf5f2-1ef4-517c-9805-6587b60abb01/18c35ed630d7229c5584b945641a73ca83fb5213";
      name = "julia-bin-1.8.3-RecipesBase-1.3.2.tar.gz";
      sha256 = "884d106bad1dc4dcc3c9416eb735d4f5a770c485db659f7bc960b0608e8a78b7";
    };
    requiredJuliaPackages = [ SnoopPrecompile ];
  }

  {
    pname = "JLLWrappers";
    version = "1.4.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/692b3bcd-3c85-4b1f-b108-f13ce0eb3210/abc9885a7ca2052a736a600f7fa66209f96506e1";
      name = "julia-bin-1.8.3-JLLWrappers-1.4.1.tar.gz";
      sha256 = "3b996a0721dd8b36625f593284b8165204b7ff542a5625adb6329a6063eaaffc";
    };
    requiredJuliaPackages = [ Preferences ];
  }

  {
    pname = "Xorg_libXfixes_jll";
    version = "5.0.3+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d091e8ba-531a-589c-9de9-94069b037ed8/0e0dc7431e7a0587559f9294aeec269471c991a4";
      name = "julia-bin-1.8.3-Xorg_libXfixes_jll-5.0.3+4.tar.gz";
      sha256 = "995d3c65b26bd1cf8f659ddf873056f8cd5fff08799e1663597f12806dc9f61d";
    };
    requiredJuliaPackages = [ Xorg_libXfixes_jll-Xorg_libXfixes JLLWrappers Xorg_libX11_jll ];
  }

  {
    pname = "Xorg_libXfixes_jll-Xorg_libXfixes";
    version = "5.0.3+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXfixes_jll.jl/releases/download/Xorg_libXfixes-v5.0.3+3/Xorg_libXfixes.v5.0.3.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXfixes_jll-Xorg_libXfixes-5.0.3+4.tar.gz";
      sha256 = "98bf6ed379dbad1a8829a99aef1ec131948ecd007e1e352330113b1452f6f1c7";
    };
    isJuliaArtifact = true;
    juliaPath = "f0d193662fead3500b523f94b4f1878daab59a93";
  }

  {
    pname = "LAME_jll";
    version = "3.100.1+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/c1c5ebd0-6772-5130-a774-d5fcae4a789d/f6250b16881adf048549549fba48b1161acdac8c";
      name = "julia-bin-1.8.3-LAME_jll-3.100.1+0.tar.gz";
      sha256 = "15748e0e431f065215a9382e9c833ddd89433e136e061b3f2893711f9e8a1cb9";
    };
    requiredJuliaPackages = [ LAME_jll-LAME JLLWrappers ];
  }

  {
    pname = "LAME_jll-LAME";
    version = "3.100.1+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/LAME_jll.jl/releases/download/LAME-v3.100.1+0/LAME.v3.100.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-LAME_jll-LAME-3.100.1+0.tar.gz";
      sha256 = "c50316310f171fb28403127fdb32ddd1e2fad2c073d57520c98d599e36f4f935";
    };
    isJuliaArtifact = true;
    juliaPath = "e19f3bb2eef5fb956b672235ea5323b5be9a0626";
  }

  {
    pname = "Grisu";
    version = "1.0.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/42e2da0e-8278-4e71-bc24-59509adca0fe/53bb909d1151e57e2484c3d1b53e19552b887fb2";
      name = "julia-bin-1.8.3-Grisu-1.0.2.tar.gz";
      sha256 = "f89b20c79f05bb792bad1367f49f2a1a9e945e2771c1b4ccec1d45a373534721";
    };

  }

  {
    pname = "NaNMath";
    version = "1.0.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/77ba4419-2d1f-58cd-9bb1-8ffee604a2e3/a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211";
      name = "julia-bin-1.8.3-NaNMath-1.0.1.tar.gz";
      sha256 = "5e64af2fe84eb3261eb25d65fd8416017d4c10f3211bb5604e46b75aaeee534d";
    };

  }

  {
    pname = "Libiconv_jll";
    version = "1.16.1+2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/94ce4f54-9a6c-5748-9c1c-f9c7231a4531/c7cb1f5d892775ba13767a87c7ada0b980ea0a71";
      name = "julia-bin-1.8.3-Libiconv_jll-1.16.1+2.tar.gz";
      sha256 = "479d2ac36f0d7da03d06d307fb41f76ec572a6af6a62e1aaf79eba914eee37b9";
    };
    requiredJuliaPackages = [ Libiconv_jll-Libiconv JLLWrappers ];
  }

  {
    pname = "Libiconv_jll-Libiconv";
    version = "1.16.1+2";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Libiconv_jll.jl/releases/download/Libiconv-v1.16.1+2/Libiconv.v1.16.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Libiconv_jll-Libiconv-1.16.1+2.tar.gz";
      sha256 = "5713372cba8664377c99247a2675ac8a794ce96911e07dc1c262c7c388459522";
    };
    isJuliaArtifact = true;
    juliaPath = "e63503984ff7722ba80209eddd5621acca0d2d5e";
  }

  {
    pname = "Formatting";
    version = "0.4.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/59287772-0a20-5a39-b81b-1366585eb4c0/8339d61043228fdd3eb658d86c926cb282ae72a8";
      name = "julia-bin-1.8.3-Formatting-0.4.2.tar.gz";
      sha256 = "7749125b91525321cf6d279a642c503c88910fcfc6cb9db84a2ad2a3bc476ddf";
    };

  }

  {
    pname = "Xorg_xcb_util_wm_jll";
    version = "0.4.1+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/c22f9ab0-d5fe-5066-847c-f4bb1cd4e361/e78d10aab01a4a154142c5006ed44fd9e8e31b67";
      name = "julia-bin-1.8.3-Xorg_xcb_util_wm_jll-0.4.1+1.tar.gz";
      sha256 = "1dc8c63f48e411e999057f2337daab1c91be9f0678a21c51b5f1896207b64858";
    };
    requiredJuliaPackages = [ Xorg_xcb_util_wm_jll-Xorg_xcb_util_wm JLLWrappers Xorg_xcb_util_jll ];
  }

  {
    pname = "Xorg_xcb_util_wm_jll-Xorg_xcb_util_wm";
    version = "0.4.1+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_xcb_util_wm_jll.jl/releases/download/Xorg_xcb_util_wm-v0.4.1+1/Xorg_xcb_util_wm.v0.4.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_xcb_util_wm_jll-Xorg_xcb_util_wm-0.4.1+1.tar.gz";
      sha256 = "7750782a89322467dcf0ddea4c765bfc4c0aaf202c0ba29c84ac180b75033a43";
    };
    isJuliaArtifact = true;
    juliaPath = "b7dc5dce963737414a564aca8d4b82ee388f4fa1";
  }

  {
    pname = "ColorVectorSpace";
    version = "0.9.9";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/c3611d14-8923-5661-9e6a-0046d554d3a4/d08c20eef1f2cbc6e60fd3612ac4340b89fea322";
      name = "julia-bin-1.8.3-ColorVectorSpace-0.9.9.tar.gz";
      sha256 = "22b3e44891ea8784790bf1e0adfa940cd3a0cd920bcd0939e8de150c5a80c60c";
    };
    requiredJuliaPackages = [ ColorTypes TensorCore SpecialFunctions FixedPointNumbers ];
  }

  {
    pname = "Xorg_xcb_util_image_jll";
    version = "0.4.0+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/12413925-8142-5f55-bb0e-6d7ca50bb09b/0fab0a40349ba1cba2c1da699243396ff8e94b97";
      name = "julia-bin-1.8.3-Xorg_xcb_util_image_jll-0.4.0+1.tar.gz";
      sha256 = "8f2abbe00d129022d7141cda5decc251e36ce6e0c0d6ed1b0691b69882e1790f";
    };
    requiredJuliaPackages = [ Xorg_xcb_util_image_jll-Xorg_xcb_util_image JLLWrappers Xorg_xcb_util_jll ];
  }

  {
    pname = "Xorg_xcb_util_image_jll-Xorg_xcb_util_image";
    version = "0.4.0+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_xcb_util_image_jll.jl/releases/download/Xorg_xcb_util_image-v0.4.0+1/Xorg_xcb_util_image.v0.4.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_xcb_util_image_jll-Xorg_xcb_util_image-0.4.0+1.tar.gz";
      sha256 = "f394b6bad5316f535149a43482945c997c7824e8c57b86145af2f1a41533ff53";
    };
    isJuliaArtifact = true;
    juliaPath = "0d364e900393f710a03a5bafe2852d76e4d2c2cd";
  }

  {
    pname = "URIs";
    version = "1.4.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4/ac00576f90d8a259f2c9d823e91d1de3fd44d348";
      name = "julia-bin-1.8.3-URIs-1.4.1.tar.gz";
      sha256 = "a5ea619ff97280efc2a33f88b270fb202780a9d6b572c1750dbf6b2b468ced6e";
    };

  }

  {
    pname = "PlotUtils";
    version = "1.3.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/995b91a9-d308-5afd-9ec6-746e21dbc043/5b7690dd212e026bbab1860016a6601cb077ab66";
      name = "julia-bin-1.8.3-PlotUtils-1.3.2.tar.gz";
      sha256 = "1de91b31d8ddf0c447a8d97e1e3506025bc174d5e431e572d9b1d5709e3dd509";
    };
    requiredJuliaPackages = [ ColorSchemes Colors Reexport SnoopPrecompile ];
  }

  {
    pname = "IniFile";
    version = "0.5.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/83e8ac13-25f8-5344-8a64-a9f2b223428f/f550e6e32074c939295eb5ea6de31849ac2c9625";
      name = "julia-bin-1.8.3-IniFile-0.5.1.tar.gz";
      sha256 = "a8c803c937e24e653503263a1ee4e0c769dfe99d6e2a4ea7bb272101dd7c4d71";
    };

  }

  {
    pname = "LZO_jll";
    version = "2.10.1+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac/e5b909bcf985c5e2605737d2ce278ed791b89be6";
      name = "julia-bin-1.8.3-LZO_jll-2.10.1+0.tar.gz";
      sha256 = "7ce0c595280044c5f216c05ee5385735e87d82860d045edbaef4c46cf0c113d0";
    };
    requiredJuliaPackages = [ LZO_jll-LZO JLLWrappers ];
  }

  {
    pname = "LZO_jll-LZO";
    version = "2.10.1+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/LZO_jll.jl/releases/download/LZO-v2.10.1+0/LZO.v2.10.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-LZO_jll-LZO-2.10.1+0.tar.gz";
      sha256 = "5cb8f8bd495d29a1ad888500312e2d5ba38ccf0980278b154051ad8bd0e6ad77";
    };
    isJuliaArtifact = true;
    juliaPath = "921a059ebce52878d7a7944c9c345327958d1f5b";
  }

  {
    pname = "Libffi_jll";
    version = "3.2.2+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/e9f186c6-92d2-5b65-8a66-fee21dc1b490/0b4a5d71f3e5200a7dff793393e09dfc2d874290";
      name = "julia-bin-1.8.3-Libffi_jll-3.2.2+1.tar.gz";
      sha256 = "e1edcee1f0f0cc66b058b29251ed6870fcaff4b8e06f77b19cfbf95a7cb90f5d";
    };
    requiredJuliaPackages = [ Libffi_jll-Libffi JLLWrappers ];
  }

  {
    pname = "Libffi_jll-Libffi";
    version = "3.2.2+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Libffi_jll.jl/releases/download/Libffi-v3.2.2+1/Libffi.v3.2.2.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Libffi_jll-Libffi-3.2.2+1.tar.gz";
      sha256 = "05e71ac9ed09bf3e5fb16ddc694dc6174a7554b4c5990e3d9502b5439ae7483d";
    };
    isJuliaArtifact = true;
    juliaPath = "d00220164876dea2cb19993200662745eed5e2db";
  }

  {
    pname = "OrderedCollections";
    version = "1.4.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/bac558e1-5e72-5ebc-8fee-abe8a469f55d/85f8e6578bf1f9ee0d11e7bb1b1456435479d47c";
      name = "julia-bin-1.8.3-OrderedCollections-1.4.1.tar.gz";
      sha256 = "fd38807159096045defafbf0f8a3df6d9308245538748310e0379484ffb4fec5";
    };

  }

  {
    pname = "RecipesPipeline";
    version = "0.6.11";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/01d81517-befc-4cb6-b9ec-a95719d0359c/e974477be88cb5e3040009f3767611bc6357846f";
      name = "julia-bin-1.8.3-RecipesPipeline-0.6.11.tar.gz";
      sha256 = "535b7688de972b2a06a9b06e72b68d6948bf5361e7db57fd3de4574d4d1225f3";
    };
    requiredJuliaPackages = [ RecipesBase PlotUtils SnoopPrecompile NaNMath ];
  }

  {
    pname = "TranscodingStreams";
    version = "0.9.10";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/3bb67fe8-82b1-5028-8e26-92a6c54297fa/e4bdc63f5c6d62e80eb1c0043fcc0360d5950ff7";
      name = "julia-bin-1.8.3-TranscodingStreams-0.9.10.tar.gz";
      sha256 = "e8ded46343fe99cb527ecc9374efa4054eab96526abf4995c20be3c87f05e017";
    };

  }

  {
    pname = "Xorg_libXrender_jll";
    version = "0.9.10+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/ea2f1a96-1ddc-540d-b46f-429655e07cfa/19560f30fd49f4d4efbe7002a1037f8c43d43b96";
      name = "julia-bin-1.8.3-Xorg_libXrender_jll-0.9.10+4.tar.gz";
      sha256 = "411c96128b915b8c58feba46ed1a307d91f8ccdf219c9731a7dfe3d4d86d1d80";
    };
    requiredJuliaPackages = [ Xorg_libXrender_jll-Xorg_libXrender JLLWrappers Xorg_libX11_jll ];
  }

  {
    pname = "Xorg_libXrender_jll-Xorg_libXrender";
    version = "0.9.10+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXrender_jll.jl/releases/download/Xorg_libXrender-v0.9.10+3/Xorg_libXrender.v0.9.10.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXrender_jll-Xorg_libXrender-0.9.10+4.tar.gz";
      sha256 = "44f42b88ba7558a7916161c6d4c0e0c9e8ee328c5c5561d7ef9ab4130f6c92c5";
    };
    isJuliaArtifact = true;
    juliaPath = "527e66fb9b12dfd1f58157fe0b3fd52b84062432";
  }

  {
    pname = "LaTeXStrings";
    version = "1.3.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/b964fa9f-0449-5b57-a5c2-d3ea65f4040f/f2355693d6778a178ade15952b7ac47a4ff97996";
      name = "julia-bin-1.8.3-LaTeXStrings-1.3.0.tar.gz";
      sha256 = "fad7e17a96d143b3c5f2185235356bfca34080bcf1e6e47879af4086f2fa7506";
    };

  }

  {
    pname = "fzf_jll";
    version = "0.29.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/214eeab7-80f7-51ab-84ad-2988db7cef09/868e669ccb12ba16eaf50cb2957ee2ff61261c56";
      name = "julia-bin-1.8.3-fzf_jll-0.29.0+0.tar.gz";
      sha256 = "2505c51121106439b4b9760cd20365994a7e54cf465ba1024f288d2786d1a646";
    };
    requiredJuliaPackages = [ fzf_jll-fzf JLLWrappers ];
  }

  {
    pname = "fzf_jll-fzf";
    version = "0.29.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/fzf_jll.jl/releases/download/fzf-v0.29.0+0/fzf.v0.29.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-fzf_jll-fzf-0.29.0+0.tar.gz";
      sha256 = "d6be08bcdab0bd2724693350698e96a307f22aa728fed1a6805d4364e280ba4e";
    };
    isJuliaArtifact = true;
    juliaPath = "6248cb1f54b1805fa1eaeeefc0f2d75f4435e69d";
  }

  {
    pname = "ChainRulesCore";
    version = "1.15.6";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4/e7ff6cadf743c098e08fca25c91103ee4303c9bb";
      name = "julia-bin-1.8.3-ChainRulesCore-1.15.6.tar.gz";
      sha256 = "842777bb9079bd32aaa615fcea423dec08b0490f14d76ccbd0466a6cb149c2d1";
    };
    requiredJuliaPackages = [ Compat ];
  }

  {
    pname = "libvorbis_jll";
    version = "1.3.7+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/f27f6e37-5d2b-51aa-960f-b287f2bc3b7a/b910cb81ef3fe6e78bf6acee440bda86fd6ae00c";
      name = "julia-bin-1.8.3-libvorbis_jll-1.3.7+1.tar.gz";
      sha256 = "f4341c63c01b75a86313601b0f89c00bf75a0312c1fd1fc5403f8aeb083c99fe";
    };
    requiredJuliaPackages = [ libvorbis_jll-libvorbis JLLWrappers Ogg_jll ];
  }

  {
    pname = "libvorbis_jll-libvorbis";
    version = "1.3.7+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/libvorbis_jll.jl/releases/download/libvorbis-v1.3.7+1/libvorbis.v1.3.7.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-libvorbis_jll-libvorbis-1.3.7+1.tar.gz";
      sha256 = "d314fdcb60bfeefdcdfd949f39ded6c75721f56f46aa83d66af019083e695066";
    };
    isJuliaArtifact = true;
    juliaPath = "89ed5dda220da4354ada1970107e13679914bbbc";
  }

  {
    pname = "Glib_jll";
    version = "2.74.0+2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/7746bdde-850d-59dc-9ae8-88ece973131d/d3b3624125c1474292d0d8ed0f65554ac37ddb23";
      name = "julia-bin-1.8.3-Glib_jll-2.74.0+2.tar.gz";
      sha256 = "05db4b9e8affc909923f8c23e6d1f64d0309dc905ccc0edd69cadbebb2010d61";
    };
    requiredJuliaPackages = [ Glib_jll-Glib JLLWrappers Gettext_jll Libmount_jll Libiconv_jll Libffi_jll ];
  }

  {
    pname = "Glib_jll-Glib";
    version = "2.74.0+2";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Glib_jll.jl/releases/download/Glib-v2.74.0+2/Glib.v2.74.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Glib_jll-Glib-2.74.0+2.tar.gz";
      sha256 = "f6b5aef42a14be2f7f1194e3d9f7f177d5d83efe8564a4861d4afc2a6f1e36c7";
    };
    isJuliaArtifact = true;
    juliaPath = "1cfe0ebb804cb8b0d7d1e8f98e5cda94b2b31b3d";
  }

  {
    pname = "FriBidi_jll";
    version = "1.0.10+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/559328eb-81f9-559d-9380-de523a88c83c/aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91";
      name = "julia-bin-1.8.3-FriBidi_jll-1.0.10+0.tar.gz";
      sha256 = "2acfbddebcecb973f601382c7122fa52bdc5354b232274aeab07794207374b01";
    };
    requiredJuliaPackages = [ FriBidi_jll-FriBidi JLLWrappers ];
  }

  {
    pname = "FriBidi_jll-FriBidi";
    version = "1.0.10+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/FriBidi_jll.jl/releases/download/FriBidi-v1.0.10+0/FriBidi.v1.0.10.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-FriBidi_jll-FriBidi-1.0.10+0.tar.gz";
      sha256 = "e0a3934f68e2a6c24cd1475e989219dbffbd31c3042c916df9a8f7877aa0aaec";
    };
    isJuliaArtifact = true;
    juliaPath = "d11639e2a53726f2593e25ba98ed7b416f62bbc5";
  }

  {
    pname = "SnoopPrecompile";
    version = "1.0.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/66db9d55-30c0-4569-8b51-7e840670fc0c/f604441450a3c0569830946e5b33b78c928e1a85";
      name = "julia-bin-1.8.3-SnoopPrecompile-1.0.1.tar.gz";
      sha256 = "48e740b80cecfac909a46ed8ab6da680d4bc67d4e6c2b20348d129914a636fc4";
    };

  }

  {
    pname = "Ogg_jll";
    version = "1.3.5+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/e7412a2a-1a6e-54c0-be00-318e2571c051/887579a3eb005446d514ab7aeac5d1d027658b8f";
      name = "julia-bin-1.8.3-Ogg_jll-1.3.5+1.tar.gz";
      sha256 = "e28b938a5b6d7a27a6b66aeed2db9ebb1c225da9d50e7da1cb918f1ceeb185b3";
    };
    requiredJuliaPackages = [ Ogg_jll-Ogg JLLWrappers ];
  }

  {
    pname = "Ogg_jll-Ogg";
    version = "1.3.5+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Ogg_jll.jl/releases/download/Ogg-v1.3.5+1/Ogg.v1.3.5.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Ogg_jll-Ogg-1.3.5+1.tar.gz";
      sha256 = "313ec9c6468b651bbdaa1035e57a960f51ef0f09ad48b7c4292aa22aa1a4ae9b";
    };
    isJuliaArtifact = true;
    juliaPath = "0631e2a6a31b5692eec7a575836451b16b734ec0";
  }

  {
    pname = "Libglvnd_jll";
    version = "1.6.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/7e76a0d4-f3c7-5321-8279-8d96eeed0f29/6f73d1dd803986947b2c750138528a999a6c7733";
      name = "julia-bin-1.8.3-Libglvnd_jll-1.6.0+0.tar.gz";
      sha256 = "1f11d2ce932667e7c150b0103e7e26f225d2f6ff2ad416166cf5a5894ee84d2f";
    };
    requiredJuliaPackages = [ Libglvnd_jll-Libglvnd JLLWrappers Xorg_libXext_jll Xorg_libX11_jll ];
  }

  {
    pname = "Libglvnd_jll-Libglvnd";
    version = "1.6.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Libglvnd_jll.jl/releases/download/Libglvnd-v1.6.0+0/Libglvnd.v1.6.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Libglvnd_jll-Libglvnd-1.6.0+0.tar.gz";
      sha256 = "c73957bc110c5897ad10107acef40b0a5c2e53f248d4e389683fe289e8c6b19f";
    };
    isJuliaArtifact = true;
    juliaPath = "37dda4e57d9de95c99d1f8c6b3d8f4eca88c39a2";
  }

  {
    pname = "OpenSSL";
    version = "1.3.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/4d8831e6-92b7-49fb-bdf8-b643e874388c/df6830e37943c7aaa10023471ca47fb3065cc3c4";
      name = "julia-bin-1.8.3-OpenSSL-1.3.2.tar.gz";
      sha256 = "8fdd9f11c5c85a56605b1d71d536414717f00d50f7c1bdb8fed0c64bf82a26ee";
    };
    requiredJuliaPackages = [ OpenSSL_jll BitFlags ];
  }

  {
    pname = "Xorg_libpthread_stubs_jll";
    version = "0.1.0+3";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/14d82f49-176c-5ed1-bb49-ad3f5cbd8c74/6783737e45d3c59a4a4c4091f5f88cdcf0908cbb";
      name = "julia-bin-1.8.3-Xorg_libpthread_stubs_jll-0.1.0+3.tar.gz";
      sha256 = "f6532d1c6f74722677a1f89633e5844c22e6001bb2bdaa0eb2a9ccc49624feae";
    };
    requiredJuliaPackages = [ Xorg_libpthread_stubs_jll-Xorg_libpthread_stubs JLLWrappers ];
  }

  {
    pname = "Xorg_libpthread_stubs_jll-Xorg_libpthread_stubs";
    version = "0.1.0+3";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libpthread_stubs_jll.jl/releases/download/Xorg_libpthread_stubs-v0.1.0+2/Xorg_libpthread_stubs.v0.1.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libpthread_stubs_jll-Xorg_libpthread_stubs-0.1.0+3.tar.gz";
      sha256 = "8cba18f2080eb2cb0ee20447faa565b568f65c82505027fc558f34400e42bd0b";
    };
    isJuliaArtifact = true;
    juliaPath = "aa3e93661fefff04200a3d0099cfdd1b5fc0ded3";
  }

  {
    pname = "HTTP";
    version = "1.6.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/cd3eb016-35fb-5094-929b-558a96fad6f3/2e13c9956c82f5ae8cbdb8335327e63badb8c4ff";
      name = "julia-bin-1.8.3-HTTP-1.6.2.tar.gz";
      sha256 = "960cbfe7c07ab5bdd80ea78b4d9481c188141995e910344e0614aaa46989c75e";
    };
    requiredJuliaPackages = [ URIs IniFile LoggingExtras CodecZlib MbedTLS OpenSSL SimpleBufferStream ];
  }

  {
    pname = "Xorg_libXi_jll";
    version = "1.7.10+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/a51aa0fd-4e3c-5386-b890-e753decda492/89b52bc2160aadc84d707093930ef0bffa641246";
      name = "julia-bin-1.8.3-Xorg_libXi_jll-1.7.10+4.tar.gz";
      sha256 = "2c77be5053d5f7ba608cb86bf63ddd27c143b8e64c174fcc9693c98b4028d806";
    };
    requiredJuliaPackages = [ Xorg_libXi_jll-Xorg_libXi JLLWrappers Xorg_libXext_jll Xorg_libXfixes_jll ];
  }

  {
    pname = "Xorg_libXi_jll-Xorg_libXi";
    version = "1.7.10+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXi_jll.jl/releases/download/Xorg_libXi-v1.7.10+3/Xorg_libXi.v1.7.10.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXi_jll-Xorg_libXi-1.7.10+4.tar.gz";
      sha256 = "7febe8f377cb502bf72f97a5cd7aaec450b87c19feeab94f1a3b0345bea6f92a";
    };
    isJuliaArtifact = true;
    juliaPath = "2df316da869cd97f7d70029428ee1e2e521407cd";
  }

  {
    pname = "XSLT_jll";
    version = "1.1.34+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/aed1982a-8fda-507f-9586-7b0439959a61/91844873c4085240b95e795f692c4cec4d805f8a";
      name = "julia-bin-1.8.3-XSLT_jll-1.1.34+0.tar.gz";
      sha256 = "379902d8943e36e8000ff7764065e50de52bb51da1255e79bed53bd9ff6b0bd8";
    };
    requiredJuliaPackages = [ XSLT_jll-XSLT JLLWrappers XML2_jll Libgpg_error_jll Libgcrypt_jll Libiconv_jll ];
  }

  {
    pname = "XSLT_jll-XSLT";
    version = "1.1.34+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/XSLT_jll.jl/releases/download/XSLT-v1.1.34+0/XSLT.v1.1.34.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-XSLT_jll-XSLT-1.1.34+0.tar.gz";
      sha256 = "e41b5251610babf93503931d2f3dfd05e1a462e8cad5246e6b58a96cf7ac341f";
    };
    isJuliaArtifact = true;
    juliaPath = "f3ec73d7bf2f4419ba0943e94f7738cf56050797";
  }

  {
    pname = "UnicodeFun";
    version = "0.4.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/1cfade01-22cf-5700-b092-accc4b62d6e1/53915e50200959667e78a92a418594b428dffddf";
      name = "julia-bin-1.8.3-UnicodeFun-0.4.1.tar.gz";
      sha256 = "716568e8870afd892d07acce887e40729b22074d8fc1622a7e21edfbf83c908c";
    };

  }

  {
    pname = "Cairo_jll";
    version = "1.16.1+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/83423d85-b0ee-5818-9007-b63ccbeb887a/4b859a208b2397a7a623a03449e4636bdb17bcf2";
      name = "julia-bin-1.8.3-Cairo_jll-1.16.1+1.tar.gz";
      sha256 = "395030b2e7d25b765a982ebba630a957c58f383051c505b6346481bf34f7ef12";
    };
    requiredJuliaPackages = [ Cairo_jll-Cairo Fontconfig_jll Xorg_libXrender_jll Pixman_jll FreeType2_jll JLLWrappers Bzip2_jll Glib_jll Xorg_libXext_jll libpng_jll LZO_jll ];
  }

  {
    pname = "Cairo_jll-Cairo";
    version = "1.16.1+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Cairo_jll.jl/releases/download/Cairo-v1.16.1+0/Cairo.v1.16.1.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Cairo_jll-Cairo-1.16.1+1.tar.gz";
      sha256 = "34627fe21b932eb8afc1607c96ebe032f9e7dcc77c33fc679563c29d3d4b53aa";
    };
    isJuliaArtifact = true;
    juliaPath = "8b0284dc2781b9481ff92e281f1db532d8421040";
  }

  {
    pname = "Xorg_xcb_util_jll";
    version = "0.4.0+1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/2def613f-5ad1-5310-b15b-b15d46f528f5/e7fd7b2881fa2eaa72717420894d3938177862d1";
      name = "julia-bin-1.8.3-Xorg_xcb_util_jll-0.4.0+1.tar.gz";
      sha256 = "93d9c4777c81dd5cc8f605d5afa5864283db47720d15861caf090c6e5a40a30e";
    };
    requiredJuliaPackages = [ Xorg_xcb_util_jll-Xorg_xcb_util JLLWrappers Xorg_libxcb_jll ];
  }

  {
    pname = "Xorg_xcb_util_jll-Xorg_xcb_util";
    version = "0.4.0+1";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_xcb_util_jll.jl/releases/download/Xorg_xcb_util-v0.4.0+1/Xorg_xcb_util.v0.4.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_xcb_util_jll-Xorg_xcb_util-0.4.0+1.tar.gz";
      sha256 = "d0412e5205795f7b766d74f642211f629eba638f14fced7114e9bc49da3112d8";
    };
    isJuliaArtifact = true;
    juliaPath = "cacd8c147f866d6672e1aca9bb01fb919a81e96a";
  }

  {
    pname = "Reexport";
    version = "1.2.2";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/189a3867-3050-52da-a836-e630ba90ab69/45e428421666073eab6f2da5c9d310d99bb12f9b";
      name = "julia-bin-1.8.3-Reexport-1.2.2.tar.gz";
      sha256 = "9d3a02aef4c4ba864d691e1ab0179423eac89e7007031187c79328441e2ab3fe";
    };

  }

  {
    pname = "MbedTLS";
    version = "1.1.7";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/739be429-bea8-5141-9913-cc70e7f3736d/03a9b9718f5682ecb107ac9f7308991db4ce395b";
      name = "julia-bin-1.8.3-MbedTLS-1.1.7.tar.gz";
      sha256 = "5ddbd78e74f4186739b5c68cdd6c70ed49fc458f36ce830f11d65e827555634f";
    };

  }

  {
    pname = "Fontconfig_jll";
    version = "2.13.93+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/a3f928ae-7b40-5064-980b-68af3947d34b/21efd19106a55620a188615da6d3d06cd7f6ee03";
      name = "julia-bin-1.8.3-Fontconfig_jll-2.13.93+0.tar.gz";
      sha256 = "99e6f57e452a66eaca3d34a1db292d6df0bdb443f9afd6d40fb76a1b5fd894bf";
    };
    requiredJuliaPackages = [ Fontconfig_jll-Fontconfig JLLWrappers Bzip2_jll Libuuid_jll FreeType2_jll Expat_jll ];
  }

  {
    pname = "Fontconfig_jll-Fontconfig";
    version = "2.13.93+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Fontconfig_jll.jl/releases/download/Fontconfig-v2.13.93+0/Fontconfig.v2.13.93.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Fontconfig_jll-Fontconfig-2.13.93+0.tar.gz";
      sha256 = "e11e34977807b958fe5e7cea59a8354d94e11a052bad1348768aba8143769ea1";
    };
    isJuliaArtifact = true;
    juliaPath = "387d89822da323c098aba6f8ab316874d4e90f2e";
  }

  {
    pname = "GLFW_jll";
    version = "3.3.8+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/0656b61e-2033-5cc2-a64a-77c0f6c09b89/d972031d28c8c8d9d7b41a536ad7bb0c2579caca";
      name = "julia-bin-1.8.3-GLFW_jll-3.3.8+0.tar.gz";
      sha256 = "b4fcd33cb82f3cec35f59c6c07bf0542d16d972512badbe0335fe3f9def8c32e";
    };
    requiredJuliaPackages = [ GLFW_jll-GLFW JLLWrappers Libglvnd_jll Xorg_libXcursor_jll Xorg_libXinerama_jll Xorg_libXrandr_jll Xorg_libXi_jll ];
  }

  {
    pname = "GLFW_jll-GLFW";
    version = "3.3.8+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/GLFW_jll.jl/releases/download/GLFW-v3.3.8+0/GLFW.v3.3.8.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-GLFW_jll-GLFW-3.3.8+0.tar.gz";
      sha256 = "77914b7ba66ccb288a018f1fba65ec8c383e17519732c23ef36fcc2adfb179eb";
    };
    isJuliaArtifact = true;
    juliaPath = "5aa80c7b8e919cbfee41019069d9b25269befe10";
  }

  {
    pname = "Libgpg_error_jll";
    version = "1.42.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/7add5ba3-2f88-524e-9cd5-f83b8a55f7b8/c333716e46366857753e273ce6a69ee0945a6db9";
      name = "julia-bin-1.8.3-Libgpg_error_jll-1.42.0+0.tar.gz";
      sha256 = "c10907db7f390438657d583f0aae6eb3bc0258c0e2d1cb6b67888f2b825cab80";
    };
    requiredJuliaPackages = [ Libgpg_error_jll-Libgpg_error JLLWrappers ];
  }

  {
    pname = "Libgpg_error_jll-Libgpg_error";
    version = "1.42.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Libgpg_error_jll.jl/releases/download/Libgpg_error-v1.42.0+0/Libgpg_error.v1.42.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Libgpg_error_jll-Libgpg_error-1.42.0+0.tar.gz";
      sha256 = "0e9750caf43757872e2bf4c4fa363b1e597913f34ff2306f97652e1c3bc47313";
    };
    isJuliaArtifact = true;
    juliaPath = "16154f990153825ec24b52aac11165df2084b9dc";
  }

  {
    pname = "DataStructures";
    version = "0.18.13";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/864edb3b-99cc-5e75-8d2d-829cb0a9cfe8/d1fff3a548102f48987a52a2e0d114fa97d730f0";
      name = "julia-bin-1.8.3-DataStructures-0.18.13.tar.gz";
      sha256 = "ae06055da23802900a179277c44ff7f74c217059f4af39b19c97f2c6010aaf0d";
    };
    requiredJuliaPackages = [ Compat OrderedCollections ];
  }

  {
    pname = "x264_jll";
    version = "2021.5.5+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/1270edf5-f2f9-52d2-97e9-ab00b5d0237a/4fea590b89e6ec504593146bf8b988b2c00922b2";
      name = "julia-bin-1.8.3-x264_jll-2021.5.5+0.tar.gz";
      sha256 = "f5a92d0dbe23d95f88b16e569087868ba3e82e7656f3d422f8a98cd9ecde3b85";
    };
    requiredJuliaPackages = [ x264_jll-x264 JLLWrappers ];
  }

  {
    pname = "x264_jll-x264";
    version = "2021.5.5+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/x264_jll.jl/releases/download/x264-v2021.5.5+0/x264.v2021.5.5.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-x264_jll-x264-2021.5.5+0.tar.gz";
      sha256 = "d2c6713284a23538db197b579a7669dff3688cf6f72cb1f81019a46cc24198a2";
    };
    isJuliaArtifact = true;
    juliaPath = "587de110e5f58fd435dc35b294df31bb7a75f692";
  }

  {
    pname = "LogExpFunctions";
    version = "0.3.19";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/2ab3a3ac-af41-5b50-aa03-7779005ae688/946607f84feb96220f480e0422d3484c49c00239";
      name = "julia-bin-1.8.3-LogExpFunctions-0.3.19.tar.gz";
      sha256 = "72f5a01146b22a52d62594d04aa9b2254806ecd70b25667ab6b00f0873a37f2c";
    };
    requiredJuliaPackages = [ IrrationalConstants ChainRulesCore ChangesOfVariables DocStringExtensions InverseFunctions ];
  }

  {
    pname = "Requires";
    version = "1.3.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/ae029012-a4dd-5104-9daa-d747884805df/838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7";
      name = "julia-bin-1.8.3-Requires-1.3.0.tar.gz";
      sha256 = "0a2bdade81b8bf0dcded6e14390220c58746f3bcd01f46c805c04215e3f96a34";
    };

  }

  {
    pname = "Colors";
    version = "0.12.10";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/5ae59095-9a9b-59fe-a467-6f913c188581/fc08e5930ee9a4e03f84bfb5211cb54e7769758a";
      name = "julia-bin-1.8.3-Colors-0.12.10.tar.gz";
      sha256 = "c1277c4a478f796f73610c88270966bc7e57d6bc76f2fea37d34e6b9f2114a79";
    };
    requiredJuliaPackages = [ ColorTypes Reexport FixedPointNumbers ];
  }

  {
    pname = "Xorg_libxkbfile_jll";
    version = "1.1.0+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/cc61e674-0454-545c-8b26-ed2c68acab7a/926af861744212db0eb001d9e40b5d16292080b2";
      name = "julia-bin-1.8.3-Xorg_libxkbfile_jll-1.1.0+4.tar.gz";
      sha256 = "76f66ab544c9e6bb060fc4e06b558f462411bfd5c9f44fb2bdee4d55d25a0d51";
    };
    requiredJuliaPackages = [ Xorg_libxkbfile_jll-Xorg_libxkbfile JLLWrappers Xorg_libX11_jll ];
  }

  {
    pname = "Xorg_libxkbfile_jll-Xorg_libxkbfile";
    version = "1.1.0+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libxkbfile_jll.jl/releases/download/Xorg_libxkbfile-v1.1.0+3/Xorg_libxkbfile.v1.1.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libxkbfile_jll-Xorg_libxkbfile-1.1.0+4.tar.gz";
      sha256 = "a50f7cc06f1a4f609ddf97e22118e3813fcc6f9e2e9d3fe321f0c2a77c5ca379";
    };
    isJuliaArtifact = true;
    juliaPath = "84f18b0f422f5d6a023fe871b59a9fc536d04f5c";
  }

  {
    pname = "Xorg_libXinerama_jll";
    version = "1.1.4+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d1454406-59df-5ea1-beac-c340f2130bc3/26be8b1c342929259317d8b9f7b53bf2bb73b123";
      name = "julia-bin-1.8.3-Xorg_libXinerama_jll-1.1.4+4.tar.gz";
      sha256 = "ee93cdef2440588dc0730d6c4ae95537445cbf1a17c7d300e8f9d58bbad88ac0";
    };
    requiredJuliaPackages = [ Xorg_libXinerama_jll-Xorg_libXinerama JLLWrappers Xorg_libXext_jll ];
  }

  {
    pname = "Xorg_libXinerama_jll-Xorg_libXinerama";
    version = "1.1.4+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXinerama_jll.jl/releases/download/Xorg_libXinerama-v1.1.4+3/Xorg_libXinerama.v1.1.4.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXinerama_jll-Xorg_libXinerama-1.1.4+4.tar.gz";
      sha256 = "9e12fc7c4d8d41fad3d3d539e04c64ab651dd109a10fe0761352f321a6f9bed1";
    };
    isJuliaArtifact = true;
    juliaPath = "7190f0cb0832b80761cc6d513dd9b935f3e26358";
  }

  {
    pname = "FreeType2_jll";
    version = "2.10.4+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/d7e528f0-a631-5988-bf34-fe36492bcfd7/87eb71354d8ec1a96d4a7636bd57a7347dde3ef9";
      name = "julia-bin-1.8.3-FreeType2_jll-2.10.4+0.tar.gz";
      sha256 = "9403236f31a1933a1c7cf37bc714a2ff8f69b5b144c8e68548771aed40c2c909";
    };
    requiredJuliaPackages = [ FreeType2_jll-FreeType2 JLLWrappers Bzip2_jll ];
  }

  {
    pname = "FreeType2_jll-FreeType2";
    version = "2.10.4+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/FreeType2_jll.jl/releases/download/FreeType2-v2.10.4+0/FreeType2.v2.10.4.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-FreeType2_jll-FreeType2-2.10.4+0.tar.gz";
      sha256 = "a3001f52ad6509380c1a36e7dfbaf100e362f9e9634dc7fe44d476710cb31f59";
    };
    isJuliaArtifact = true;
    juliaPath = "54c97eb1b0a6f74bac96297a815ddec2204a7db7";
  }

  {
    pname = "Xorg_libX11_jll";
    version = "1.6.9+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/4f6342f7-b3d2-589e-9d20-edeb45f2b2bc/5be649d550f3f4b95308bf0183b82e2582876527";
      name = "julia-bin-1.8.3-Xorg_libX11_jll-1.6.9+4.tar.gz";
      sha256 = "d20dfaeff568e736a9993743a45a12d09e11dc29989e4995e816536f794adfa9";
    };
    requiredJuliaPackages = [ Xorg_libX11_jll-Xorg_libX11 JLLWrappers Xorg_libxcb_jll Xorg_xtrans_jll ];
  }

  {
    pname = "Xorg_libX11_jll-Xorg_libX11";
    version = "1.6.9+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libX11_jll.jl/releases/download/Xorg_libX11-v1.6.9+3/Xorg_libX11.v1.6.9.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libX11_jll-Xorg_libX11-1.6.9+4.tar.gz";
      sha256 = "07ece1dd93146db1f25b829eb895e769652eb97bf90725bdfbf07b8e4c4afab4";
    };
    isJuliaArtifact = true;
    juliaPath = "431a0e3706ffe717ab5d35c47bc38626c6169504";
  }

  {
    pname = "JLFzf";
    version = "0.1.5";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/1019f520-868f-41f5-a6de-eb00f4b6a39c/f377670cda23b6b7c1c0b3893e37451c5c1a2185";
      name = "julia-bin-1.8.3-JLFzf-0.1.5.tar.gz";
      sha256 = "dc774b93cb932dfa8d1be8ea4a4cd7912f17aca916c6ac75c650a03387de79f4";
    };
    requiredJuliaPackages = [ Pipe fzf_jll ];
  }

  {
    pname = "Xorg_libXdmcp_jll";
    version = "1.1.3+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/a3789734-cfe1-5b06-b2d0-1dd0d9d62d05/4fe47bd2247248125c428978740e18a681372dd4";
      name = "julia-bin-1.8.3-Xorg_libXdmcp_jll-1.1.3+4.tar.gz";
      sha256 = "1ab7cdb4794cbd9e56eb22f150dcc19284ffeb0b8404356ae43259ae902a502a";
    };
    requiredJuliaPackages = [ Xorg_libXdmcp_jll-Xorg_libXdmcp JLLWrappers ];
  }

  {
    pname = "Xorg_libXdmcp_jll-Xorg_libXdmcp";
    version = "1.1.3+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXdmcp_jll.jl/releases/download/Xorg_libXdmcp-v1.1.3+3/Xorg_libXdmcp.v1.1.3.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXdmcp_jll-Xorg_libXdmcp-1.1.3+4.tar.gz";
      sha256 = "2692189b5fb2bdd90525a7bfbfa96e9fd65e6461d993bbfb1e575ca8614c0cd2";
    };
    isJuliaArtifact = true;
    juliaPath = "51c48c945ae76d6c0102649044d9976d93b78125";
  }

  {
    pname = "MacroTools";
    version = "0.5.10";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/1914dd2f-81c6-5fcd-8719-6d5c9610ff09/42324d08725e200c23d4dfb549e0d5d89dede2d2";
      name = "julia-bin-1.8.3-MacroTools-0.5.10.tar.gz";
      sha256 = "1a4a49b4e4954a68e930227bd3b1a84f2f932bb9d91f3bf76bb236d17ffeead2";
    };

  }

  {
    pname = "StatsAPI";
    version = "1.5.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/82ae8749-77ed-4fe6-ae5f-f523153014b0/f9af7f195fb13589dd2e2d57fdb401717d2eb1f6";
      name = "julia-bin-1.8.3-StatsAPI-1.5.0.tar.gz";
      sha256 = "8e77072da2cb1ac42d795a8bf71eb3e539024ea845aba6e4f9f39b1d9e1b4f75";
    };

  }

  {
    pname = "Compat";
    version = "4.5.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/34da2185-b29b-5c13-b0c7-acf172513d20/00a2cccc7f098ff3b66806862d275ca3db9e6e5a";
      name = "julia-bin-1.8.3-Compat-4.5.0.tar.gz";
      sha256 = "630582931b884f8fd6a55e293ae530d8fe9be00107a88da2febef63e935ae07e";
    };

  }

  {
    pname = "OpenSpecFun_jll";
    version = "0.5.5+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/efe28fd5-8261-553b-a9e1-b2916fc3738e/13652491f6856acfd2db29360e1bbcd4565d04f1";
      name = "julia-bin-1.8.3-OpenSpecFun_jll-0.5.5+0.tar.gz";
      sha256 = "825dfeca597116dda8b49a6b97f9e3692eb18e72f2db10043d86b9df04446e29";
    };
    requiredJuliaPackages = [ OpenSpecFun_jll-OpenSpecFun JLLWrappers ];
  }

  {
    pname = "OpenSpecFun_jll-OpenSpecFun";
    version = "0.5.5+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/OpenSpecFun_jll.jl/releases/download/OpenSpecFun-v0.5.5+0/OpenSpecFun.v0.5.5.x86_64-linux-gnu-libgfortran5.tar.gz";
      name = "julia-bin-1.8.3-OpenSpecFun_jll-OpenSpecFun-0.5.5+0.tar.gz";
      sha256 = "320e4c5ac643a4994de91e6a708973d8944a4413385e0ba7d2f5756276cd53cb";
    };
    isJuliaArtifact = true;
    juliaPath = "abf4b5086b4eb867021118c85b2cc11a15b764a9";
  }

  {
    pname = "Xorg_libXau_jll";
    version = "1.0.9+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/0c0b7dd1-d40b-584c-a123-a41640f87eec/4e490d5c960c314f33885790ed410ff3a94ce67e";
      name = "julia-bin-1.8.3-Xorg_libXau_jll-1.0.9+4.tar.gz";
      sha256 = "c63300ec31e85667a7e7cc80eb1ccbfa8253373154c739ee8351edad85941e51";
    };
    requiredJuliaPackages = [ Xorg_libXau_jll-Xorg_libXau JLLWrappers ];
  }

  {
    pname = "Xorg_libXau_jll-Xorg_libXau";
    version = "1.0.9+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXau_jll.jl/releases/download/Xorg_libXau-v1.0.9+3/Xorg_libXau.v1.0.9.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXau_jll-Xorg_libXau-1.0.9+4.tar.gz";
      sha256 = "763b24fb4a12e0a7d22b3a8f2f90f72e35b37c90771d1dcdad0d2d1e69f36e71";
    };
    isJuliaArtifact = true;
    juliaPath = "4487a7356408c3a92924e56f9d3891724855282c";
  }

  {
    pname = "Xorg_libXcursor_jll";
    version = "1.2.0+4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/935fb764-8cf2-53bf-bb30-45bb1f8bf724/12e0eb3bc634fa2080c1c37fccf56f7c22989afd";
      name = "julia-bin-1.8.3-Xorg_libXcursor_jll-1.2.0+4.tar.gz";
      sha256 = "e555ef1cd4b272cdb4a4365e0896f46b40b7ffb23ef1a9986184a790423aa9c3";
    };
    requiredJuliaPackages = [ Xorg_libXcursor_jll-Xorg_libXcursor JLLWrappers Xorg_libXfixes_jll Xorg_libXrender_jll ];
  }

  {
    pname = "Xorg_libXcursor_jll-Xorg_libXcursor";
    version = "1.2.0+4";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libXcursor_jll.jl/releases/download/Xorg_libXcursor-v1.2.0+3/Xorg_libXcursor.v1.2.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libXcursor_jll-Xorg_libXcursor-1.2.0+4.tar.gz";
      sha256 = "f7352a518bad4916015c1ad87949771d27e5e2fe12d50da73ac8ebf036c575cb";
    };
    isJuliaArtifact = true;
    juliaPath = "05616da88f6b36c7c94164d4070776aef18ce46b";
  }

  {
    pname = "Unzip";
    version = "0.2.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/41fe7b60-77ed-43a1-b4f0-825fd5a5650d/ca0969166a028236229f63514992fc073799bb78";
      name = "julia-bin-1.8.3-Unzip-0.2.0.tar.gz";
      sha256 = "0a1af06b4b122aade8eba295cfa1b9a15e3ae174756809c51979c9cc5c6a6801";
    };

  }

  {
    pname = "InverseFunctions";
    version = "0.1.8";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/3587e190-3f89-42d0-90ee-14403ec27112/49510dfcb407e572524ba94aeae2fced1f3feb0f";
      name = "julia-bin-1.8.3-InverseFunctions-0.1.8.tar.gz";
      sha256 = "f0fae28ba4324b659ef14b699939038e83566300120f3b09fe80e4b0aa4792c4";
    };

  }

  {
    pname = "Libuuid_jll";
    version = "2.36.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/38a345b3-de98-5d2b-a5d3-14cd9215e700/7f3efec06033682db852f8b3bc3c1d2b0a0ab066";
      name = "julia-bin-1.8.3-Libuuid_jll-2.36.0+0.tar.gz";
      sha256 = "15231151e1d742f34eee3e8b059f827dc17e4f0bc778a4e23cf0fd1ca505452d";
    };
    requiredJuliaPackages = [ Libuuid_jll-Libuuid JLLWrappers ];
  }

  {
    pname = "Libuuid_jll-Libuuid";
    version = "2.36.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Libuuid_jll.jl/releases/download/Libuuid-v2.36.0+0/Libuuid.v2.36.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Libuuid_jll-Libuuid-2.36.0+0.tar.gz";
      sha256 = "b541ec7a6ebf63916be7142507a363d744e9ed138138272e5bf08774899e866d";
    };
    isJuliaArtifact = true;
    juliaPath = "2b77b304b0975d15bd5aeb4d1d5097ac6256ea3c";
  }

  {
    pname = "CodecZlib";
    version = "0.7.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/944b1d66-785c-5afd-91f1-9de20f533193/ded953804d019afa9a3f98981d99b33e3db7b6da";
      name = "julia-bin-1.8.3-CodecZlib-0.7.0.tar.gz";
      sha256 = "6238792a7d5afa51092b3b2f44db5e63f93812f41defd3e63085018df40735ad";
    };
    requiredJuliaPackages = [ TranscodingStreams ];
  }

  {
    pname = "SortingAlgorithms";
    version = "1.1.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/a2af1166-a08f-5f64-846c-94a0d3cef48c/a4ada03f999bd01b3a25dcaa30b2d929fe537e00";
      name = "julia-bin-1.8.3-SortingAlgorithms-1.1.0.tar.gz";
      sha256 = "51c443bef2340c0b0fe9580b8b88a42f64c7878f6236eabe8a4fa73561cb6b18";
    };
    requiredJuliaPackages = [ DataStructures ];
  }

  {
    pname = "StatsBase";
    version = "0.33.21";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91/d1bf48bfcc554a3761a133fe3a9bb01488e06916";
      name = "julia-bin-1.8.3-StatsBase-0.33.21.tar.gz";
      sha256 = "a1f589f846b592e0248824be1ee01c685c12fd44da44bfe76009433339f7e3e5";
    };
    requiredJuliaPackages = [ LogExpFunctions SortingAlgorithms Missings DataStructures StatsAPI DataAPI ];
  }

  {
    pname = "Missings";
    version = "1.1.0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28/f66bdc5de519e8f8ae43bdc598782d35a25b1272";
      name = "julia-bin-1.8.3-Missings-1.1.0.tar.gz";
      sha256 = "11e5a721007c88a80e7e49b4a8ac62345498b4a284a9bd1599cf30e435caff94";
    };
    requiredJuliaPackages = [ DataAPI ];
  }

  {
    pname = "Xorg_libxcb_jll";
    version = "1.13.0+3";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/c7cfdc94-dc32-55de-ac96-5a1b8d977c5b/daf17f441228e7a3833846cd048892861cff16d6";
      name = "julia-bin-1.8.3-Xorg_libxcb_jll-1.13.0+3.tar.gz";
      sha256 = "a17c907ca19050608ab2e22392f6628248dd4b4464f8fb7956b134429c8bdd65";
    };
    requiredJuliaPackages = [ Xorg_libxcb_jll-Xorg_libxcb JLLWrappers XSLT_jll Xorg_libXau_jll Xorg_libpthread_stubs_jll Xorg_libXdmcp_jll ];
  }

  {
    pname = "Xorg_libxcb_jll-Xorg_libxcb";
    version = "1.13.0+3";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/Xorg_libxcb_jll.jl/releases/download/Xorg_libxcb-v1.13.0+2/Xorg_libxcb.v1.13.0.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-Xorg_libxcb_jll-Xorg_libxcb-1.13.0+3.tar.gz";
      sha256 = "643036861ad9b2a5555b281616ab44dbd506fe3e1bedc5933fefc79eeeabbb25";
    };
    isJuliaArtifact = true;
    juliaPath = "5ba11d7fb2ceb4ca812844eb4af886a212b47f65";
  }

  {
    pname = "ChangesOfVariables";
    version = "0.1.4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0/38f7a08f19d8810338d4f5085211c7dfa5d5bdd8";
      name = "julia-bin-1.8.3-ChangesOfVariables-0.1.4.tar.gz";
      sha256 = "9870d26baa5339b2082176bda264e056df510690a994b615051467fb2cb8f691";
    };
    requiredJuliaPackages = [ ChainRulesCore ];
  }

  {
    pname = "libpng_jll";
    version = "1.6.38+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/b53b4c65-9356-5827-b1ea-8c7a1a84506f/94d180a6d2b5e55e447e2d27a29ed04fe79eb30c";
      name = "julia-bin-1.8.3-libpng_jll-1.6.38+0.tar.gz";
      sha256 = "211e93a0d57c7375ec6373161470f1e424a7283d0d1cad7cca387258a0482447";
    };
    requiredJuliaPackages = [ libpng_jll-libpng JLLWrappers ];
  }

  {
    pname = "libpng_jll-libpng";
    version = "1.6.38+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/libpng_jll.jl/releases/download/libpng-v1.6.38+0/libpng.v1.6.38.x86_64-linux-gnu.tar.gz";
      name = "julia-bin-1.8.3-libpng_jll-libpng-1.6.38+0.tar.gz";
      sha256 = "444268a49548a199d471769bd2d6438fd43b61597c2511249d34b300d19ecff2";
    };
    isJuliaArtifact = true;
    juliaPath = "ddfc455343aff48d27c1b39d7fcb07e0d9242b50";
  }

  {
    pname = "DocStringExtensions";
    version = "0.9.3";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/ffbed154-4ef7-542d-bbb7-c09d3a79fcae/2fb1e02f2b635d0845df5d7c167fec4dd739b00d";
      name = "julia-bin-1.8.3-DocStringExtensions-0.9.3.tar.gz";
      sha256 = "10654268d0cf20c4d0ee4b8c991861407227d186e799858a55aa54a9a960d853";
    };

  }

  {
    pname = "libaom_jll";
    version = "3.4.0+0";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/a4ae2306-e953-59d6-aa16-d00cac43593b/3a2ea60308f0996d26f1e5354e10c24e9ef905d4";
      name = "julia-bin-1.8.3-libaom_jll-3.4.0+0.tar.gz";
      sha256 = "e82f9e8486936c4964abff4a916c0ad651f2ff6bdf435d4e7350a570d156abcf";
    };
    requiredJuliaPackages = [ libaom_jll-libaom JLLWrappers ];
  }

  {
    pname = "libaom_jll-libaom";
    version = "3.4.0+0";
    src = fetchurl {
      url = "https://github.com/JuliaBinaryWrappers/libaom_jll.jl/releases/download/libaom-v3.4.0+0/libaom.v3.4.0.x86_64-linux-gnu-cxx11.tar.gz";
      name = "julia-bin-1.8.3-libaom_jll-libaom-3.4.0+0.tar.gz";
      sha256 = "a3a9df2a3fdce42edb3d1f0692ca68f2da301b3c963641e6dd3de7f215f2b96a";
    };
    isJuliaArtifact = true;
    juliaPath = "595f9476b128877ab5bf73883ff6c8dc8dacfe66";
  }

  {
    pname = "TextWrap";
    version = "1.0.1";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/b718987f-49a8-5099-9789-dcd902bef87d/9250ef9b01b66667380cf3275b3f7488d0e25faf";
      name = "julia-bin-1.8.3-TextWrap-1.0.1.tar.gz";
      sha256 = "6aadf30bb836806a57e3e4c356dcfff9d00ac3011a58e3a0944eaa0587f526a9";
    };
  }

  {
    pname = "ArgParse";
    version = "1.1.4";
    src = fetchurl {
      url = "https://pkg.julialang.org/package/c7e460c6-2fb9-53a9-8c5b-16f535851c63/3102bce13da501c9104df33549f511cd25264d7d";
      name = "julia-bin-1.8.3-ArgParse-1.1.4.tar.gz";
      sha256 = "49844c982b493f6751cfae5c23f72fd481ad9ae8da05d93ef4628e8e4dcc3213";
    };
    requiredJuliaPackages = [ TextWrap ];
  }

]
