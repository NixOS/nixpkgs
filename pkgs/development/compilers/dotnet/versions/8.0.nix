{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.17";
      hash = "sha512-7CBEGt44FE1zkTlbWuztY05SgJsBe4NTVQUOgCCEb6Y/SwHW3hcBP/H7Jxt5rWBCmVB3Gn8THi+fldHe+g3V+w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.17";
      hash = "sha512-3d/oVZzNM1+MSLPNdeassLrOlgZuFcSEZ8z9JjofhRdPSLZwVPuYiX48ylLlyXiY6WdMGn6i2kcHI3NUZ7TQmw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.17";
      hash = "sha512-SVpn42wW9M6HI16kOeaM09nw2SlZsgsZCHTzBPBGrVRDblwcUV7U6MxMgH9XwrqSTziAZgLhIwR2BHvHwvoxWw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.17";
      hash = "sha512-Hh4MgVIOGGWATWiysB1uCATWEW/nwNaYtQcTpkVJ/NBJmzVrwx/GQQBYe0uZwiRQ8npGEBvouS0tha/5zjIcPQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.17";
      hash = "sha512-KzLfeiD/vvTNuuWwq+yzUP0anje9vbqC+COuV1lgsD25zyUAyJwYthDVyhYdZ07aZNs7V1bx8yoMcUUL+ql3sw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.17";
      hash = "sha512-490ItCA3f0tB89YK/p9mf6UB7w8tNusrjUYRpzXomG9TtOScyKaFmSxvRHaaeWGT/bbOpaitLSaWKKnnAxFKkw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.17";
      hash = "sha512-47EF7FIww1odYFPgGkZdkbazfOhxVCH5VfvU89ht52DzsdeRun+u53SKRRQewcku3M76JXlPAUaWYF9YEbRhKw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.17";
      hash = "sha512-P3X61aknNd61nNPPeRvxZmKaX35fNrlmcZ6f2EqSmRFjSmVaZRY5AW1jHx+P3zyc+f5sKVvSDSe+cBwM6sIsKQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.17";
        hash = "sha512-8NI7LrwgScvsfnIvIutWgDBNZv52afHUqTkQhiOYXg7kRUQ9VQsrV3wR+hnHo/WGlSibGcNBHz9hXRXGL3PApQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.17";
        hash = "sha512-qNBOlNW0AVi2ZzOUgYpQIwr8ZFkY/64+59pYYwG2+SMtkwTJdOYTNX9N03gODk7tUsIzJpZ7aBLo6KKMXgRX/g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.17";
        hash = "sha512-t5PXM7/aThrr95wvivIB95usffttNzSxLKlCH/6breXbQ4pVVD/rRIvfQbsC+z5S3cqkyfr7bcbqdevY2i7zzg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.17";
        hash = "sha512-MIU7+TheXyNxkcnDwBhQMLc09/id6XFqvxpZZqMQ84UH18/56YAxsPmZdkKPCXTmQhcPO45//vrDYP0FfrRHLA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.17";
        hash = "sha512-2Pg0cRKKLlIs4ZJP3p97BYAXG6Ttnl/4xC0EMqvpiigljSSc/4loJpEceFjA9SEcBISRtm0yg5tB9CKUY7JGAg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.17";
        hash = "sha512-SrlXcJ/A68zSy3e+NOYPB+7BCjjKE6QjSxKEAkdaNBwBBPvMC94tnYUDxKhES/6Je9guGE4LF/A2nEe2RNeejA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.17";
        hash = "sha512-FAOcrRdUyHU5QBDf+4GSjyTPb0nw+NhdF4hkQjsKuzlmUdbY7jbsEY8xr8nfOw+dnKNcj+4N0VGlqKT5zKnZOA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.17";
        hash = "sha512-YJib2fbiDQeWrEoAVAyVBa+ASWXJqjHyygr/9N9qHWAIuQn4F9PBkJs90ZBkEGxFhLGOsV0dLv3QSSfn9G9anw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.17";
        hash = "sha512-9AZNX0abD5AXz0PARFGU5N8jxBeuEAreZrMcsjuWqm+diyA51LCWJeGkG0HJ1XV88G9hSLn3gTCadhPKiYe8yA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.17";
        hash = "sha512-W/OdiSQkTscKsj2LZ6/Js80unCUQeQFPFUheOIayF0jeXZxBz2mgCv1W2bL2N6dQu/XzY+rcdAVaK84EctpyBw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.17";
        hash = "sha512-Ld0Qg6YLHXSqbizrz4a0ycPfuty79ZK4zwAcguHZNS3GplRI9yJPbv/XXa7ENiSMOiFTWZjCpZ9mMTkJkLj7JQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.17";
        hash = "sha512-5sPZOZbgvw1k9mDnT0sQgYC9L90+Th2RlZquaEK4vYYb7NqwYddV6iipqF9zghrMzztK85Pym2bJZlKSn1fjsw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.17";
        hash = "sha512-w7EnpLx0V3N70/DdDyJCQV/rF4xtUTNKX3Ii4le1dTb7DxvqkplJ9Vf2y7l50i4dW8UEKtdfBED1BUGJiDx0Fg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.17";
        hash = "sha512-hR1mk1E3E8bXdt0q1yFkB7HlT5vJ+BTbrNswKt/BivmT3/qgjTAyJI/24FNkmPKg6e+k2+stvV9vMxFjNWcWbg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.17";
        hash = "sha512-F7MdXMz1cekBW9GMQ+U2CuFoMpBcAgkecJgZt96YfJEyCXVJotmGTMHB2pYoGBz0TU3307tg5JIfUd2d2Jj34Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.17";
        hash = "sha512-wgx1oeWwzdttunh9nnm4HXv6REofxaCTzmlBGgffonufjSK4vkzr/dLsq5bkV7Sj+/5sOc6qLesIwx7nUChllg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.17";
        hash = "sha512-ccX5RLNKPjmuagvmwkiONFgZuJa7qWFGCPjDm9WSK4efJ6CYFcNJmfTLHQMZ+fgyGzTnD2A5zMP/0Ot1o7xQEQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.17";
        hash = "sha512-gqi233hXdnvcE7McL/G+TR/BN+MYrmau1vL1E2uXmtdE+GB/pPWQXzYnxAeRM6jbC3ku0YKsAk+5lnRaZ5dsXA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.17";
        hash = "sha512-VsSVyCQbOvBD5tFuWknajmz57qGHqwP7Pvts+o6SJ5UEUSTPPlzREqSfb1oIntmkFgfFGOZdc/MeL2hIQdADRg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.17";
        hash = "sha512-u9hkQnH4virFn25AXmV9TLhpuRXfXiBmx/q+uSWaBz2CZmT/EY6e0kRL5gg57gtlfkItKg5rgXnClk2gWvmIQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.17";
        hash = "sha512-0O+bU5EYdrFo3W0z7kHqfzV8r+hr/mboeekd/ObmPERfXYhn64W3qI0g3YfO+KHWiCD3rTju7gM0odZXXFu6xg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.17";
        hash = "sha512-bJUphLGlvIBzrN/VwTEJnrI0ul7mm1GiG5HzthokhjE53M2hdPw1jFEpp9A2wFOHAuj7rTJFfkJwyrmVoL2TKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-UOJ/eDhYZLsxGAWndocXEvpsKhxK+qkpTz6rBhsfLzJ0JMH3sYqSO4JDJV9rECYrkrcMbI4DjMJFQL9iNmyQTg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-SHuKMrh4ogiLsi6KGG5ziwKdu7ipPWKF+pjNi+lpXOhaSquyxiOQUSaHn+Cw7gIpunuJbnpHmWjSh3KSYgRxSA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-n8gVagaXe5iFgulX7xVJBCV7YHYuaxI8+ExUb2mRqFJ6Ova8Z99vlqANna8PiGbkVzy6FqoS97gguMfa7eXnkg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-Xij6YAKzsmctbLeLJES2CKFnACvnCycv8EMOPPu7DcNnYHg/OOsUe3ObfXeKU5yhCW85wSM2NFwPiv8eO9Xe/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.17";
        hash = "sha512-7AEQKppA6Meq5duC4IrlJgoyfwJLNpsBtbFfaoKhUvvPfyPjpI6rT1GtXVafMGeclVEMjW56PPv6W9kSHTD3GQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.17";
        hash = "sha512-HJ/MHBFPWz0jeIW/8uoqHi0zmw/pY8SafYfG1l7I1vQhO+scdPp+W2dWFyPT7atiOubc1JC+ozrA3E4bLguZmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.17";
        hash = "sha512-zcgek5WOy0/XY/kRbE8DQpRM5zdDWlO6JV1bfST6hKlawEeMX0h+Amm1VdYA4SxHehgPuDvMM9NQo0MLUOiMMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.17";
        hash = "sha512-oFYo/d2Drv7914y3mzKdJ/18Gshple5H0FRsXUvCLWThrlYCFyjyhmEyToOMXLFHP1HWQ19xAzZPs9pN/AtePQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-/E7gmctuYf5c45e5VREjE+BvVrVDX/yHoRTpCpeb89TE/a4q5BSxRNutlNlR89JKGRNEN5hKOGSpixNN30NJPg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-DeNAP4VlvWX4hCek+RuQgt0C+QYBTpY8LBbIer9S1QXH4gM28BGtOzBUW5xeZ2nUik5QpP3hKPQk9UHnJQ8ABw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-Aas+h9qheCOnTGOclCdfq3FeqTQN9+qhw9v5Wc3UhMt5hxkljzRhMKWPTNokM+erTb62C0RfFmNnEcUmm1M9fw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-Gg4T5ZJNQO1Ov8X3qB0gT5Nd57bD1uDgJFChmpdb/qRj5c6mHN42Nz1POnvz/ZxyIBZqTXSAK/Sh7hYwhnO6Cw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.17";
        hash = "sha512-u4SWuPRUXOxPTwHv6V2ePpZFw+D5/mE+zlq+vgk9B0odHvArhLFBsxSdq2OVzjx7T6OXnm664ySu1mWuZiRtLQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.17";
        hash = "sha512-ksN26mFXeA3pkdTQIuhEbODXXhTgA24UoJLaj02Jr3OezARLCRs/kg4FIBpazJ2I0xI5oQPe0b8BiGQlW6Vt6A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.17";
        hash = "sha512-SXqdnf+0qa3qjodEeBKQyjK1EOh50Fzymiz6PtOfWkcAESLXlE+UtImtxuE9tvjUwjBc2Z1zeiCyaGOhpVzh3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.17";
        hash = "sha512-7bIfsRP0cumDeTb+iOYm7+gnWLDx4nJcpM3OrkAjZS14CmQfWzXckmspd12sOHBir3gJaJiBLn5IOhuneoN2lg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-ISu7M97fzDxM+s5dlutK/xuI0xj6yOAFgTZ0F6EZSMmwoNRN/SOXFtwnMQFoDCyNsTFP1RRIyHB2GHBnWzkeeg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-FPBQGj1ec4f56WOS2vaKfQcu3ddB4N6aiW9ptDGnLslTs1SqLs5ROthMmGSptfyXVMaksbCQ36Dt4FlfKaQ0aw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-JoUr84iXSEzSt9qob5wFYBdvG1d0OalPBqMHKUM/W0MoAmvrAB7TynbY62B0xB/pH4u2th41AD0teAqJrFWLCg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-VlGSzLStxk86aalHNQ7lMcr8KaZ2OyOqklv1rXT92cwPpkY1+F/yrCOa5w4OIKL9CmPPfOgCvhTYq0sDPeKiSw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.17";
        hash = "sha512-QprkNU0qUh1rafUqBtf74gHyBv333CUbWqAlet4lfMGO5fUkriLhvckuRYGwAdB9UuN/p1gNqHeMBddqwrx62Q==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.17";
        hash = "sha512-4gpidP+3KgWOg8V7X3QZb1bHRY6DuZq7k9JgUETydSL7s9oVKEF8OU6Uuajmxn5q2HjTII7UO+/Ost//wXxJgg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.17";
        hash = "sha512-fkY3BYk1K5zhi9MDTU/+oAz1o7+BzMaghJf7wDAnrIa0Uv8rHH6QFlUktqL2XTQaQyFi9AHKRwk6+qMVNMygjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.17";
        hash = "sha512-eIlHY8UjZ0/h9fB23z60HXc0ZZgHsysSTivqkO7TEajctBS6INfqvCqQ5xJsM/3al61rZhZdJdIuIg0mQ7ZuYg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-UuP+BTHKYuNk9efX3dLcnqH+tK4uCObd4a3JH4was5IP9lrPlTst4shN+CrVASQZ3+1Mv+ofQCQzYF42sRN6yg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-3zek/zAOEojwKUANBjeWlnsPyWbbavnJ3o4VHMdmKR2dRk5TPU1oy8DC7vVk+rd1J0V6hrokxagxYL1+mh7sMg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-OT2bIhD7vAgcGQy3T9wAuhCch7euvV7LTM9u06XVt8PfBe7ws2//NWklbN205WxR/+zKw9LA+WV0+ZluaWPwBg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-XIJ5AewwwMSntIdaU9wjGq5nnC7pt4Je2rOT3caGAZVUbMI+TLdzjGC4ySIG4EzHNdb0ioazDlpm59XYxFjtyQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.17";
        hash = "sha512-Hi7EwkTaHTX+ORY78yBJfQIa0Li6QTM+bCgYwiJS5piw4mNbtsqg8JnzMTBTyL8RcC2Az7skktgUqrnQYPbE3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.17";
        hash = "sha512-A4YO9NwkU6D/STwctlJU1W5uoGbSX05dWd2hQfriwS+QvSJAVHJfiuCd/obr+K6caCBz7QaB4atsbObXye/upA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.17";
        hash = "sha512-aziQHkE0YNyxANTFVFO1+j+NiAuqIrQLWua767eM+XCgwkdYd+SuuT3dDk83QJnFqHrLsoztdnFkmG0RjiJmKQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-HMJ43Pe4Bsk1RrKocroaQztnSZacp2KR9Ens5hf/2A9M67ag8pE9AC27Jnsm5123wYnK97MuLa1EhSzqjUJ3tg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-76AdyyHdR+8w/Tf+eYbV0QAxceqvyAc05W0tWv/L8AhxH8DEdsv1RyXx1jTySd+CuGyTbb0Bmwd7NUdK7XCWJA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-F4qOt3rF+aVxj+cMT04cc9GsLEhdcM36I7rAB05tHjxpYum29Cd52UL1E02n+Cb3AMWaOkFm3uZKbnuWHhCOMA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-LnqYt32luIPGBIHWqkQqZII4JyVH2eV1cciCIsz/o0GSomy+IGPw8QirHSFchQhm9qIgS7swoXHEnBoVcXDa7g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.17";
        hash = "sha512-N5OgMVCqVq8v2L2LFcriguocIU98C72giD0eKgFirCst6beO71PU8sJyYNjRknl+L4A+uhDUsZfpLONDMz9vVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.17";
        hash = "sha512-bosx45pWfzEme1le8Bm75n6gAMSrlCe9+NmRoo5f/ZrpsPZq7zRaLVRlXB5XKi36Suq7BQjsJ67ubGNqF+Iz+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.17";
        hash = "sha512-5EJos1FnyGO5/7tjtF4MdniGBr19ZehLUwhblPnGTx3kyGPf+imGpA34HmKB0Lpf53nYXDBOiWrqUHl/dURarw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-FpLu/8+PcuX8fNcnCGDED2WWbrlNvV9dpiZ49e9rAcDBlYg9aoNBEGGP9HJ45uATmJW/V55BtNxGJKXucceAMQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-uh9Xyw8G1nbUdmTUOeiDyn7LXBrEO3slJJwkRC19AqirVspWFWuDliiIj/GAStnF5EDYepgfgC2WeTr82hnQMg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-JXyOaJZcJQvu+UvZrLDeXY+QgpgMSqBGvL7oKDfvJazL9wKIJDA6A68v8RfSlLTyiO196XrV3XWNTbCC5CWtPQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-Fkm//A57PJApgtg7jUySUGtz1arRGwXipRpl4lczOuol/hmKb6FL9eN6fYNYsU/LiA+xP0d72prlTyYEifRPHw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.17";
        hash = "sha512-AqkVaugZa6Tt4z+yeGqqlSlhDw4Q3gtPdXNFu05fLjAQi4zAvCccOpjMmwca41Zteiu9qGkfQwFDyO1LQXThMw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.17";
        hash = "sha512-ViTDLKPx1YPdbj1xTx6LSXLJ4y+LQKfbrqRNw4PN96i7dcRviRt60R7BKfV+sdsDOaQtYDhUr8/1CGPaa9SnDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.17";
        hash = "sha512-tGoCDChhmw1PPPpWNYfo7tjJBy4NIRkgkCuSXPBUiLNcKmkeMAhA2N2MUvVKxhoayCL1K49clw2CDFG1YSDC4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.17";
        hash = "sha512-jSQpm6cwP9IbEc9/v2esVv2NJ7O21CklPxOjHSWvM6VcwH3/vAEy21wX+JOM3G4euTWCKxMxOTAU5bXL9fpV+g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-ejOqr8hAO2d1Sxxkn9d+xiVLCeQ4fkBOyTEsgliMkFnrJaxFxdV+Q1I7RtoYWJH/DoseqVW5vn5CAgGnY7yPiQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-twUxbIlZzPNoJx/nxQlx98TiW1JV6NnpHqvgQhGE3VloeEE5AiPUg+UVpKa42id/K3GEzOpQ8CGAnB+phyOhwg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-o/P+ZRj6LjjGJdaazlvz/ysRQumAUbrfOmXLQz17RExXc6Ikk7yQ3l7EJAuWO7U9LwlU5ubXs6uVqtKyv7vnHg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-sNM9LGQom9BS5lEV9VQt3dTweI6q+2fgdfnjAaqmMCM2un4aKT8vNK3oegOEPhigBQp5GB7Z7+CgVBhYiLiEhQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.17";
        hash = "sha512-NvQn4WyGdNXAVaUYu30XY/XQqTWe65HGMDKNAxVsYbNUiNecXjE3ZhkiRyLa9HU4l+6n3ouNNzYHg1Z9MPukpQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.17";
        hash = "sha512-lsYscCD0qR6XsXqJrM4evxEB4qNSu5QEvH1mb6JK8iQN05kW05CYP9IfBBVzQR3+iik45gnwjUFrokNnl9LMig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.17";
        hash = "sha512-A3RrznTiIIpaE04b1cNY6Bx3pEmAqa9ig9xwoUuAlH/brYtOuvo3JoehwVgpfZm7dzMblRPuvu1J9SVagyNEdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.17";
        hash = "sha512-pvPS0TivFj3n6V+v0ivlhOc1HvkZnQBnnH6y9TZCw/nkkKjuTJpjS+x5xWHy4yLgdB64hfCpfc6g5578ib3OGg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-X0Mt5TbPJlG6LzwHP/98DB+TqCwF5toyO40QLZiaWBWH8gdkXxZsnqSwHBixe7jEDB9knpUQs3nWvG1wf9YOCA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-LtMIjhBaZld9EX8YChaTicl79vEo9ci+H+16xqWm6ksvYyx0vbameWRWXQ3i4KgUm/klwYkzGeKVzzll53itgw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-qxknZ2pQrvLXxASaCeyy5Ox9rb27jzwh4DAu+I4pQRl7qSfBVmqLtoAtZ6tSBj6crAt8/5q7mW16Av2RejDk3g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-qWhils4j4HijPnFQHpmeOUudYMbX7BrYZedABWp3Ddsf5xoTLPSzUTssPFgrX5zhuI0eC+ACXQDCc3RRe16PZQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.17";
        hash = "sha512-b2jQNPpO8zaXgyvO6uG6ABXWO1qRYJvSiZWMXlxzAX2FCOR2AqfNiMbuJOscaqRyo1A5EZl/mKhNWbjvZ+Ie8g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.17";
        hash = "sha512-Gn4GGWnOSo9W/5GfgqwWEyZ1AwV6JVc4DBcq+IbPTZviND+0j5ZUJsF2xzPcgEYre8XYFR+tf4KqV2S+t9DRCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.17";
        hash = "sha512-9ef3DABF5Em5tOne761hyzBpUrOnWuucfONtUsxUWq2pZiGpk9AoaAOJxf766qdQWL1SQ0sJYRGhpJ7YfKX8Og==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.17";
        hash = "sha512-E+7CArIcwuTmkSfCdZneueDRZy3pT77DDZXvwuIDTyojOrdGVlj4hzpqSzmqmTnr5Cg8uT34XxnYOH1cAQiljg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-X3/73Flriad7tsa6o4GXXG0JMz5M1gaJQ5wXatZk90P2Eg3uDLOnqb6upr0x2495gDI4aLPPmDRvaArZoA3w+w==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-1/aUPzhPQ/bKVm5NoP4dNfc9B/C3eqRu+gv6bLroPxiS1JjHKL/iG4aPeFP/Gr0zt546bKd56Ac9t0S+ZpgjeA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-u+V7Vazc9T1yrKkAtGgCaVrm7777F//PpYlXlKi8LCEMmzsjgTqXDv+96blOjqNfFFG5nDH7Wrfy/EuNxbggEQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-it7TtIOtYcV5XwMQKpIsD1mKrqUimH4VK7uJct4sCZGjxfgrhf07l/yI91A11WVJubQHK5cq7KeCirqGoEtAsg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.17";
        hash = "sha512-hCDJrREXgVISf2dXVj9+0NGUYr/Hk6HH0pE75ubOaQO42n7gH1EyuhF7fgMKVCjhnYblRML6WKuVDIbkJoUbtg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.17";
        hash = "sha512-FqJc/4qewgmg/1yamy4kyTvTntC1e+qN92mN1co8BT163ZkWV9RtGgvgb/yD+0th3/nOEb+xcu7EVNNxzTJZLA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.17";
        hash = "sha512-0j8M6HzQLzZPvWl0TM0VlsWVtMGrKNrLPgmOcu8vXz4QoMq4A2y2md3cmdpX5PatjcEwKRib3pg0iGVyrefDgw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-yQVr2/oC7L2zGbX4zG7z0cclJb1YALFciH3U8zc/eS0Ta4CmAXREmeTT2JaqY7U9hAEz8f8TzzX+JtB6W7PADw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-vVJFuE0gTSWBpZr3Qx6EitWtvIXW5BMyorvOSmOV14laSaGuhrddbz1OtbQ2qTOw2++z2AoIIRzKNiyDZ54jLA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-piZCbDE18Ca9OjU365hOClMWArbcXmj5Qk7oXE/4pXY2Mrdoo9R6IKQo9QT5rZ7qOO25W2X49fC2NCpt9WR1Cg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-e77ZoQafeMCWXiQ4pqeWAS969lzHjTO/Nl0ISpmItUBXdSkrOaThpWew4hp2AuS98U3wv7yAb2snPOOBkRRuwQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.17";
        hash = "sha512-gw2FwvqE1xSNnFdCQ1PE1AZjdjmwi8Qo3trC+xfnfHy89/ljYXbkoyeIQR7irDllbJwlmI4gAKbwHFXYLO7I9Q==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.17";
        hash = "sha512-4+mkaFTIo0hySyHps1L8jaeHS7otI51G3J2Jwy9hYY2tGlYCRmYJm75KjMCgFjaijuAuv90xRME5bxSw3JIzRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.17";
        hash = "sha512-V5rRhz0of2jLYzhsNtABdw1ZhRjN9EcDeFzX4baN9eWrgR6IIt+pq5SCpPMm+qQJLH1IZDoS6ZwmcBVTs3aGWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.17";
        hash = "sha512-DVkgTu0W/491HH++XjvPJh+tbGjHS/NAqEyyFNZtcepvskdQG3tiazPvBrKAhe5HfO6xCY65TykNy4znepkXyA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.17";
        hash = "sha512-IN34IGuBDaTS0V10Ny52Fw+Fit4+onsnfceySIYoNH5p60jEMGbyXXMIQrhqvw4eIlaIKOTNwSo7cmvAcz7N9Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.17";
        hash = "sha512-izNgoKUSHtsl4N2J1L0WjaclTj1myk43zFIKie+y/+0uYDJ2QQL+pL9c1pOpHs/FKXDySLt8b3jtj1mOgcHEvA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.17";
        hash = "sha512-0FgjD+98nDYlSqXqP1Emka7T7LfpvSrYz1ag/fBBpVqZmmekpV1BM1rXQKDB6ruSkmmkMn41UD4MrvXykzYmZA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.17";
        hash = "sha512-gCqz7CcfeAP87TsYVTc58vmINB8CY4KSG/pLiWycqrIZHmsdgw6olcCe/xbcm2N1mSMaD9pfMMkAI9nHDn36RQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.17";
        hash = "sha512-YEx7Me3MPRkXTNcIJ6ROh6lxN0f9V3zc21Gna0UzlImMYtL74qdCSnpV3ztLGuDMKJZYYQmCbpVb5kmxxSMIGw==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.17";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.17";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/aspnetcore-runtime-8.0.17-linux-arm.tar.gz";
        hash = "sha512-EwhWW7qG+JHlwU/iKVzJ57jgxygwyPqy1qDVkd6WZ9jEV4RaUPZvBdMhik0rHdQ7CK44ENhnLFpaN4n0bssY1Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/aspnetcore-runtime-8.0.17-linux-arm64.tar.gz";
        hash = "sha512-TxpEHkALYPgUoWHScYwlmbTUkv/+XfWl2KSUzsVTrTV0wJiOncSav4ySi56Xg6hvVQbLy98S0k5WIJCWms7TxQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/aspnetcore-runtime-8.0.17-linux-x64.tar.gz";
        hash = "sha512-spLepS9wA1u3zMgsHtkI+whHU+sI9mLHuy6SBuIvOWqmEdtlc+gn1cXP8hWQgQtm6uDq2bU0vD+PxpX2X0fyjw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/aspnetcore-runtime-8.0.17-linux-musl-arm.tar.gz";
        hash = "sha512-DEsWquOo/z751KXI3qM7mw/rS2x2dFhB7Npyhj7BZvGm1VnhArdELf/B/yLIpVzn7jrXsV8MdWJRVruTGP6UWQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/aspnetcore-runtime-8.0.17-linux-musl-arm64.tar.gz";
        hash = "sha512-6eyDEAZZUCxhFJn5JL/EdMLmSRtRjtaXOZGcCXp5m+57Sk3SPtsfDnho+86RmOSx0WVF7FFEpVuYIMFmWw3Phw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/aspnetcore-runtime-8.0.17-linux-musl-x64.tar.gz";
        hash = "sha512-o1QPicloU1OO4RQUWsmZHyIr6JFbgDlBkYFP2qvvOrwjXWBXmfo3WWLAkJrwOz0L8ax2A0LFZhQNkU9/cGaSvg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/aspnetcore-runtime-8.0.17-osx-arm64.tar.gz";
        hash = "sha512-eBdKcYFy/lGNAEo8H+/L7HMe32jip3dMb6lRIwgRUvLJUe/mxhStnB+RWJfAl43GD+ecn5tuw+KKHpBQ94U2fg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/aspnetcore-runtime-8.0.17-osx-x64.tar.gz";
        hash = "sha512-P1koY2bq198GFJUHuMHHkE5hSg+U2P8SjRrAS55LL6owje62extXbEA5HNWSaTYXuwVIoUQft8VeF6dFb3nHnQ==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.17";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.17/dotnet-runtime-8.0.17-linux-arm.tar.gz";
        hash = "sha512-u2G7Xl3rf7wDDAh/2mA738EqgzP7QK6752Df1cSkmkoSsqYDqhzhb2ZgZNb5OuwS/hb3E240tPXheX4Yc5hPXA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.17/dotnet-runtime-8.0.17-linux-arm64.tar.gz";
        hash = "sha512-5C+8g7+C7kIvF/Hrcu5/T+9sGQSPrqEGBYcVwXX7iKqT+K+02dHfaC0Lz05n8aH0xpz7QtXTxm3YYoqO/ctBEA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.17/dotnet-runtime-8.0.17-linux-x64.tar.gz";
        hash = "sha512-1XM4i9ZN6xLmRk/GpCQPbtfNHGsXNwCWMEuKwtgAMYw682+BhaO3gK/lKwQYJN7vnTd6lqa67XWcgoOCkFRkmg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.17/dotnet-runtime-8.0.17-linux-musl-arm.tar.gz";
        hash = "sha512-MHewWpOmltw0lw1ibcafCOFzw1S72XmZFATXmJnEHr8/upiE1CqPhS5IHuhdjKhesq764x+OSusvdpHVHp3z7w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.17/dotnet-runtime-8.0.17-linux-musl-arm64.tar.gz";
        hash = "sha512-gH6LRXbnGWJAY0nzJQaltKvXKR1L98lR5euA/KzPd8w/G1f+TnEQ0LcWlVTg6JBcSYi7dBfwMJvey8rcquy9Zg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.17/dotnet-runtime-8.0.17-linux-musl-x64.tar.gz";
        hash = "sha512-6prPLtAa/fUdiQiXboZjXXBOFSSdet5LNrLcifBO247YK0DgUxXOz1/cDpKd006VgPcDeSEprSxc4koDsKYkbg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.17/dotnet-runtime-8.0.17-osx-arm64.tar.gz";
        hash = "sha512-n3f8O0/8yixku23sVpGoNDapoQTSnHGBC1+khTUCbuyx+7x4Ae6XgzNhmPDQj8kts01VkyeMpcE2A1Vthnph3A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.17/dotnet-runtime-8.0.17-osx-x64.tar.gz";
        hash = "sha512-+vANPgV66ZcfMKKTfDI39so/qUkDK9q5KasLr8mXtCPBglMUCr3/rRa8tFGdSD+4tdCwP+PmPjRwWHmxqNbsOw==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.411";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.411/dotnet-sdk-8.0.411-linux-arm.tar.gz";
        hash = "sha512-YAYNmPje2xWxG4/KcJJpqda5RKeHHezCOM9/WIt4wS9zt/aPIb+h18JHq03tXLrUl21quPvlmkrymNU9DAN1lg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.411/dotnet-sdk-8.0.411-linux-arm64.tar.gz";
        hash = "sha512-f9cMl+VJ6HPO77Yu2f7zF1l/swCw+VSHhYcZojHm0zNDDHtw4CyBBcG6Z5RG9gVq8ActIsFzaJBtlEkfRwUTbA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.411/dotnet-sdk-8.0.411-linux-x64.tar.gz";
        hash = "sha512-5zBMN5jDrTJ4ojz6x+P4c6dg1r/gcZ6q/fapZmr+/48nMOfIT3/1l9NLXibRvMsI7MbiPH70N2VkxO1WjW0kMA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.411/dotnet-sdk-8.0.411-linux-musl-arm.tar.gz";
        hash = "sha512-aXxS3PIBEGxRzsx12ahB8SreFuijwvfkKxZxnFcDHFSaTjulBE1q0CAa0RaCDjbiCp2NVX1Dae9SMUc/9RO2jg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.411/dotnet-sdk-8.0.411-linux-musl-arm64.tar.gz";
        hash = "sha512-E1T66KTG65g+A+0AWYng+QjlS7kt6dkV+E13yvXr0T2q7yGRbGs677Pmo2mLSOJbRybV/tOfC1EvUXVH4MluCQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.411/dotnet-sdk-8.0.411-linux-musl-x64.tar.gz";
        hash = "sha512-1GIcGYtrn6uKfz6UItc3fCZxiA2PEE9s1bqwFl8ILR8vCjQdMwW7zn3w/N/2lsBhtOqq0aeoTwjEuMH7hdZQvg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.411/dotnet-sdk-8.0.411-osx-arm64.tar.gz";
        hash = "sha512-2ZHAegXD9H7UyFEdTymMyT9fbGClUnF89bm4+OM99tNnal7TP/8JlwAPU31ZdZnR2O6tqPpXdcasPB0uqAVURA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.411/dotnet-sdk-8.0.411-osx-x64.tar.gz";
        hash = "sha512-RtcyQBGXqdCNFiveiIMvQlRrGliZ9hSRQAh/V7T2OvcsjbgxrebNkQ/RPJHeYoACkK0SkSbJ/GpsTHdqZb7eCg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.314";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.314/dotnet-sdk-8.0.314-linux-arm.tar.gz";
        hash = "sha512-GT2/BYixOzB7fklts1171djdkhpofI3GEbgkHw6mf6ouzfondNg7XttTl7QHtwlCD8KYQd2igeiboE0jqx0y+A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.314/dotnet-sdk-8.0.314-linux-arm64.tar.gz";
        hash = "sha512-qBI3o0okZeTEiukg0QllVn8bAbxkbTR4yVXpjU0Xu03fkfwwP8H4WVaufu0dgGco1/94C7NSAo+ZoCbY2yHg2g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.314/dotnet-sdk-8.0.314-linux-x64.tar.gz";
        hash = "sha512-r7sNcDkueSwLWLn2TX3W+UV2DHm7OZXTvFmYxtEPOHlOVs5jTVIHRkMBwLDbYKltPfb4O2i2yNZtenbkZrSxIA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.314/dotnet-sdk-8.0.314-linux-musl-arm.tar.gz";
        hash = "sha512-Ylw1hRevy8bNArDzkHWOAGw78zjAsLZfMfToixZ/+kKkNKTNpmA6azJ0wRcGJtbX7BYABQArtka9VH+m/ILe4w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.314/dotnet-sdk-8.0.314-linux-musl-arm64.tar.gz";
        hash = "sha512-LP+BBEU7oWaFs9wRtGlA6dsIM4f0nQOUI/wCglN2yY1Ekq/Ea0MKLoY7GVLS7GuW0EIzeBkeTFiSOh0KrBWqXA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.314/dotnet-sdk-8.0.314-linux-musl-x64.tar.gz";
        hash = "sha512-9XMfOVx+QUJ4XtrXS5m7ZEPq7vBpsVbkf0pu+1lK7hPcjD+Cb1UYJuq+0bnB434pzKnOMdFQ/+PioRlzbDHCJA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.314/dotnet-sdk-8.0.314-osx-arm64.tar.gz";
        hash = "sha512-iYlBXnvVjE2aTmjMeMxYuSbLjuNHhPV5+t9BkJyadMFMAQCnMGrC/1HcMso5dwT+nEUq8Mpqu3a6L24R/4Rgjg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.314/dotnet-sdk-8.0.314-osx-x64.tar.gz";
        hash = "sha512-iFQLs1cB4jM/QgHCngXz0nziXpnYz8ZHQR4xibH67JppYb786sStaVG+b7lpSJIern4s7yLbqgl/pcYplNt9dA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.117";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.117/dotnet-sdk-8.0.117-linux-arm.tar.gz";
        hash = "sha512-CgzKANmRmMKHWU7s/z1Kxm8yqhhtuDt4gicZu+pnLIdGA66Du6xnsmUXvb0FkZ6fGJE/wX8cwNUa1H2CHicxvg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.117/dotnet-sdk-8.0.117-linux-arm64.tar.gz";
        hash = "sha512-m2XhpXkkDlNweYvR2F8+D/5rj+t7bIgyjbkHBq037jjiBDlHRbd4tZ3UHAZMA6N8B/DeU09/D+AR0TDGJjYUig==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.117/dotnet-sdk-8.0.117-linux-x64.tar.gz";
        hash = "sha512-pnObWHt3axVv/hnSVxGxQSYbe1vs/wDLga7lsvBpT0YAeZxiXrhE1bp0ID3VoSEdw0urYsVJYf5+t6kuGn2/dw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.117/dotnet-sdk-8.0.117-linux-musl-arm.tar.gz";
        hash = "sha512-BUD69RdN8N2xb8DlyobhKNDUteSSnfYjpBx2sG8w3UjRENILeFRIBkID404apOcTtlXUKfvNNhf4K2CVxHlANA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.117/dotnet-sdk-8.0.117-linux-musl-arm64.tar.gz";
        hash = "sha512-2Rn9gNkGDv4f27BHZU8k3k3DngfQI27My3AfN2R+a1i7QQVXmt2nT5xAkZCK//Wr777DbIG0hYisbRY7IigE6g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.117/dotnet-sdk-8.0.117-linux-musl-x64.tar.gz";
        hash = "sha512-8BtBJhZ5lcNSYv/ndp0hymsFWzmIL1zMtoU6wvTDBzYlByDzicy42RQywYLkldWbhrPDbR7facGUJkkmUlsmRw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.117/dotnet-sdk-8.0.117-osx-arm64.tar.gz";
        hash = "sha512-asjtVua8XA2rnp11nv37jqtpDknaTzJqple7pPBzINi7VAM/xw01AIdrI9tX2FqmgyXXZlNbkqirJKufSC98ag==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.117/dotnet-sdk-8.0.117-osx-x64.tar.gz";
        hash = "sha512-sOvJ3YuHX8e5TphubByaLVFhPjKXkWMwUITalCNeGXSmFIhSgdgOKCfhXXd1u4u/AAH3dR/mgZH3EL2rJGXl5g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
