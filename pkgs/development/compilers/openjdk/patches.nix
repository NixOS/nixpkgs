fetchurl: fetchpatch:
# JDK Patchsets
# Each attrset is the name of a patch, with a list of patch attrs
# Any version that does not match a patchset constraint will not have a patch applied.
# Each patch attr has the following values:
# # EITHER:
# # path: The path to the directory where the patch is found
# # func: A fetchpatch call to fetch the patch. Available so not everything has to be vendored.
# # AND
# # EITHER:
# # `only`: Specifies this patch only applies to that major version
# # OR(must have one or both)
# # `atLeast`: The patch is only applied to this version and higher(INCLUSIVE, so "8" includes 8)
# # `before`: The patch applies to versions before this number(EXCLUSIVE, so "8" is versions before 8)
{
  "fix-java-home.patch" = [
    {
      atLeast = "25";
      path = ./25;
    }
    {
      atLeast = "21";
      before = "25";
      path = ./21;
    }
    {
      atLeast = "11";
      before = "21";
      path = ./11;
    }
    {
      atLeast = "8";
      before = "11";
      path = ./8;
    }
  ];
  "read-truststore-from-env.patch" = [
    {
      atLeast = "25";
      path = ./25;
    }
    {
      atLeast = "11";
      before = "25";
      path = ./11;
    }
    {
      before = "11";
      path = ./8;
    }
  ];
  "currency-date-range.patch" = [
    {
      atLeast = "11";
      before = "23";
      path = ./11;
    }
    {
      before = "11";
      path = ./8;
    }
  ];
  "increase-javadoc-heap.patch" = [
    {
      atLeast = "17";
      path = ./17;
    }
    {
      atLeast = "11";
      before = "17";
      path = ./11;
    }
  ];
  "ignore-LegalNoticeFilePlugin.patch" = [
    {
      atLeast = "21";
      path = ./21;
    }
    {
      atLeast = "17";
      path = ./17;
    }
  ];
  "fix-library-path.patch" = [
    {
      atLeast = "17";
      before = "21";
      path = ./17;
    }
    {
      atLeast = "11";
      before = "17";
      path = ./11;
    }
    {
      before = "11";
      path = ./8;
    }
  ];
  "wformat-fix.patch" = [
    {
      atLeast = "17";
      before = "22";
      func = fetchurl {
        url = "https://src.fedoraproject.org/rpms/java-openjdk/raw/06c001c7d87f2e9fe4fedeef2d993bcd5d7afa2a/f/rh1673833-remove_removal_of_wformat_during_test_compilation.patch";
        sha256 = "082lmc30x64x583vqq00c8y0wqih3y4r0mp1c4bqq36l22qv6b6r";
      };
    }
  ];
  "fix-nullptr-cast.patch" = [
    {
      only = "17";
      func = fetchurl {
        url = "https://git.alpinelinux.org/aports/plain/community/openjdk17/FixNullPtrCast.patch?id=41e78a067953e0b13d062d632bae6c4f8028d91c";
        sha256 = "sha256-LzmSew51+DyqqGyyMw2fbXeBluCiCYsS1nCjt9hX6zo=";
      };
    }
  ];
  "make-4.4.1.patch" = [
    {
      atLeast = "25";
      path = ./25;
    }
    {
      atLeast = "11";
      before = "25";
      func = fetchpatch {
        name = "gnumake-4.4.1";
        url = "https://github.com/openjdk/jdk/commit/9341d135b855cc208d48e47d30cd90aafa354c36.patch";
        hash = "sha256-Qcm3ZmGCOYLZcskNjj7DYR85R4v07vYvvavrVOYL8vg=";
      };
    }
  ];
  "fix-oopdesc-ptr-alignment-ub.patch" = [
    {
      only = "11";
      path = ./11;
    }
  ];
}
