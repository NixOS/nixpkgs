{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.2";
      hash = "sha512-5UdlvQgLHbSf3jWNIQsIgQXX8bpLPwT7Ula86VPEKYTNsxzati7wSst3w84cafWrQMIGkVrOWdhAbQWBM0LAFQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.2";
      hash = "sha512-zkZ5R92aVAnzQvvVo5GEUgw7LtC/EGEgScLcPxcAy9+wKn22ttlC6Y0jJVbmpvn8lSw65k4v4vZB9JTa3p0zVw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.2";
      hash = "sha512-Vj3zAxAV4RbAOv84QgWXFWfAPD2899tCGxAWYoeA4lbK/+piihilqglICYNUOUaOpWZk9lp1JH8YqzvUGL8gSg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.2";
      hash = "sha512-XMUBd3Zp2dMhtPfaI1uKzIwoyTLml+HPOpokh37gP2XLTyq9n/oXVbsyy4c5Qb9DoArrDxTjH3kZVpRYGCXM/w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.2";
      hash = "sha512-UqcE/MYZ954B09TZaoWziBOArkLQIjTLTs5j80iqo9G26HkukEvxn4fQ3OG7+hONoIGATR8QAi6C4c5GxRGg6g==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.2";
        hash = "sha512-UA3vQVkpqQKjUZMERbbute1QxpwOM8bZjVjcZ7ZhbzZ7mIBDv6XgJPKubLwukk7GHxCkPf2AV+XXm2ECieUjtw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.2";
        hash = "sha512-Cmib09h/yribffQnq5cU6jaxi4DpfhFr+lLaWrxPfVstmBsx/1oQgsWl+U5zSRim40ZdH1EixJoRRbwEhFf1rw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.2";
        hash = "sha512-/RkAhGaGWD5xlj+lgwEsje+nHEjauGvK/iNWVSwLyi4FSek38rTO35HqwLZovqKCGJqZQtLQQ3eC6CjHhR7scg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.2";
        hash = "sha512-ld8hVstWuRRJZodUxLd5jdAPMK71xt30NLeMZIVcFsQcsQ9CP9qt0PpjDyR0y+ZSwIQkm7pnvl7BEq7xTCVcQQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.2";
        hash = "sha512-D31woF6UsteTEHnFFxddJmpX3amTkUi/hGvnOt3FX4i6BVOKkqsJIf1x45MQUXf+O5E9q7nDDprgJPxOHA7wPw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.2";
        hash = "sha512-kQDgMou1CnrcX9ADD4nIcy0zkjT65pBlS2GUzoFhXdS8mAqkbCxANlHS4JBCeTZ8eZSZjT0QapAkD7DVKEwvww==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.2";
        hash = "sha512-gacWyUCxmriKo66scvwafULnOI6xClFtKAqIymOx0os27ZJD/SPEvDdkPKykkqSCNPse00qUW/W36xgcfIhlGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.2";
        hash = "sha512-wbdVbAVjSh0H3TXg8BywEiAtAwCjcHTKYNIhYscjhWaXRW3fm6Lc7Cud9XUsaiM4K7OPDzWfgjGp8CTydvccYA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.2";
        hash = "sha512-a8M6vtlcxrbJ2J1E0bvNTKNj4ryTw5fUeIdRydIY94TPWKfU33BB3GGq2VJJhgRObKZx4+OI+Iv8k7BAU9TCuw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.2";
        hash = "sha512-cv0CJDz5owemAyOBOMXhVVaavPgs/H73iSwcsv7ddB0BAxhH9RarCKgX579cKbeaD+gtCdZkT7pNN8lufUAPWg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.2";
        hash = "sha512-SXlfpzNHG40IJq1KE9Ypc4pExnlY13HECPQ7F1hc0u55LGWoEieYE4se+rZq6ygpfY+lG8jYXhYZ38dX1iz1VA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.2";
        hash = "sha512-OmoWAZ9xkufpTtLaSGPKmJBq4Fhf+vSxPjACtDUO341k6rGXt3KTtgv2Axl9hERQIGxJIErGDAfB4Kvtpaxe+g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.2";
        hash = "sha512-eu+OoIif75S+08+bSlHOHhb/St2DheAjjP5NyNu+bpoIpjIsRJJFU1l3Ozfsfva8ZolJOwO43PhmSIGBEBh7eA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.2";
        hash = "sha512-a80YIRtzJ4liuCAI13NKFVzWXhJH9pIvlPHGC/OD4nXsF3sJ+3xrQLSCSKVRyLoPQzMMhYTAvZY+DnzPEpCS0A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.2";
        hash = "sha512-4/ly70hswwZqiiFn8N/hkjQpRl5l/CiYMKjZr2QEmZqOvgwsO/JztISm72sFEnrhl64zZDUsValNspfV3dz0Fw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.2";
        hash = "sha512-DW9WHmEenrCXtzxmU6k9M/YeypSgJcyJ2YxLSVpzgc6yYUpLloS3eZu000bdNuqJjmRsMbO+YbeDlXvofsJMaQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.2";
        hash = "sha512-6npczhggIdAm8+WV/58LMfczmhac4PruV1SNXRrfEdiu83eONsiXU/RA+79hchTPIjoDx34sAlnQlFv3GJPUEQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.2";
        hash = "sha512-7G8+mwyW5PTEyG4K8xfVvvTWHvbpVDdV08VlbhRqlNpbJlffBtLWaQtnyCt0lPFsKi8w6NT2JEjZYerKsPqz0A==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.2";
        hash = "sha512-xAisQfDV6+gbh0DVYd+74hdDL3n2gu+uwvrHvOcjS0O16xjK8F4v+hQEJ4QAg2/lFKo4W7a4MMH6cg2ICsBFIg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.2";
        hash = "sha512-B2nakKuJA99k9cm+LMPc4UmEP/jAuQpj+yEMTIVsPS+l6kTDXw9ApjJVwzL0V8BwhNxBbV4248SxFLE+aK7jVA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.2";
        hash = "sha512-jz4BsoVvrlBctPmLVSP3+w5Nw02baXDvpf/hzIC+BfMDjupS/MZOKQc1dy8V5an2QIEPqaUmboRtvaMHOGh6Ug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.2";
        hash = "sha512-vvtkrG6HJep4qsNI7PQzIAOnY5AYc0qJ2KQkTMXlFpsg1pl/ZyalXD5xsIfWBPJ7/LfF5dNR1SkG8H8sCpsMSQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-yfP6uokF49n0udnmwxYEy3zje+qIlv+oQ//CqXZug9qxPX4DABfSgTixVXdAH01iCtxWS4MDZJkcv3h6oKCFZA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.2";
        hash = "sha512-wrydWg56hOFX+IMX8iJrsXwv2rbb5klrPdAov8KqNcYSMUL+RPWRMxJk6nCvsLVX2ISbrEJD57J/xDjB9kTB/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.2";
        hash = "sha512-hkiJZ53XdVrUW4Tbb+vEpoFgS68UcJZ/8OtbXrXCeuKKo0NlFEPggQH9UAeRfHiT1/MxT3U6RmdOwOLPF+oOAg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.2";
        hash = "sha512-OhSG4c0DlZ+UsVlHlOKSj7jaJ4ec7ZseHKbBq4OM0uIqDLenhYH99b4e4ZF+rXT9tUdMWlv4KidQY+0s136Itg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-mkwMXr+Pnm3I+Urp+TZEFGqrPtflW0Ja/19YpnYDrjKhB/OxTOotb44sRmZFfGIcxflR8e2QK5KVawSz8ulSWw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.2";
        hash = "sha512-TH4+wHu2vvICyB8t5kWqJosqkdCT4vXVWZh73m8Ddafa1d7Cqa3EMruOX7dBBYt2MdT5IvLNpyPZEKPc9fF4zQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.2";
        hash = "sha512-JPEfNNTf972F9GRgXT3YwkL80I9VySIGliVHp6QU72mgBn/YQtzICLnHdKZLPfjdjLB8jCRHzyYofAjAImdXRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.2";
        hash = "sha512-wiVQYMRoujDTzCo7n7LtkQ4LTPmyhDM9/sm3nfKCEL5sAEQFsNTVdPGF5ltDqPHILOjrkOI6BvGbxq7OMbnh2Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-6jxM428hmJM3RpuvwsRhyjJrsb42+P/fFQBJVb6l7S4zXZHX2yLnN9np2Nbii31w+26wiujl4J8Z3IihJ0q1vQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.2";
        hash = "sha512-9OdCIs8uygtDrvr3SrY0s6bl7FnlvEe5sxGjuIqoel2XanAAo2O7YSJrQx8aDVyXkyQnizzlEb16oCA4EWf1vg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.2";
        hash = "sha512-tCVrizZ+4iH4SDobtoVzqBdOADYfe68bdulktuwUC5sWPW1LHdmGLMSKaJiqupXphuWDOAbHUpGtCzBV9/L0TA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.2";
        hash = "sha512-aKgwBz7d3SEpLl43k7tkds2bDJcjvpQzjUJTaPwR3haX3ueeTO3e3RHKEfSuINDrsj2xBQopQmVtuAAfogtg7g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-bYxwKSniEPSnPLXdhsNrXM3xnT6BWZDBJAW4EPEsx7+U8ncwQyhck7M/Ta//J/ay8pJNVu78oS31kN8TKFusYA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.2";
        hash = "sha512-VmF7l4TWo5c/iKCK8ZqyVW8LrsgPRO17g7cGT7+aXFul7iZ8DvHZ92MKvB8GOU8ituiw1DzfshPCp68eX0gwIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.2";
        hash = "sha512-p6QlmeC3ZZNFSAN/0KkMHZeYNVY6G0+d65e/wtyGwKjTQ9tnsJ5tmfLxLgSuh5sASGNWTtfkji9WzcrpGrKKNA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.2";
        hash = "sha512-q+SsGrAvPxIWpOXxiqeE+f/LSHd7p//ohIfmWd2K1+tk+RO6mVVnAo8LVzoFun2ooLca+nrzhKJgOYziB+gYuw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-3c7noA+xvmQ0jHXPY5sKtsiVHeyTaXbz22Z90kjiruH9eyX5bmx1w2HN3mBjVxWTPA4QulFhv+oHMlfBlK3cEA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.2";
        hash = "sha512-Sa8owRalIJoJhmGGVfaqfiQhL7QPn4KOXcitPJYRCIDg8TnZ1VE43uyDgr/UCF6IbR++9m5kPzQIvns8F1Tkfw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.2";
        hash = "sha512-wZdjJQJAvvqkUNGNiSi9zwbXEp1wNKCFGc20acagFEq9xAvYBNTyc4L/5BaPr39Rsfd3wAZQGdYx3Zyt2R3P5g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.2";
        hash = "sha512-3xhjfDSMN41fJi3wj5IEqfGBRw5p6L9zZxuE51gCHZwCdbl1j78Jhuh0IZZGhfy6TG6AItEi6YpIB5nLq5dIJQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-SZ4waJ4GjoeTc+CY9QywCCLtl9x6Kon5Ylrh3dxDRUoiCMpzVlCLZM0DkaIUrAdcXX7VomWtwW/FeCCpOTNW/A==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.2";
        hash = "sha512-0F/LPTF2uXNC6U0dQcumlQ9gBenLZF3nFOmTQnZAmXrm+3ej/b3t7JMNCwcbmclMUvhks0d95QJRDQkZ7qRbmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.2";
        hash = "sha512-9OPvQJzgQOMiG1+drj/50D4QhJxNV9lQFVy9XTdoj2FUO6fDyCvAQm10acq5KKeLUnEZO4hFcYakZjmb8Z6XQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.2";
        hash = "sha512-tbL6fllK0UxBFjmsdi8Cf+iAHTrCpRxSmPxrgfXNbdyUQrBHTT7yUlKGIlzW2CQKlTZGPSURsAWCSvAr+519fg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-oVbhX4JUS7hqqVNgCwX+hWzm8CGLK5zMo7J2PXRwzYR/xVWkWuVuf73LFs2Gz8YtJZlq8PzPT1S9iWzceUp6WA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.2";
        hash = "sha512-9z+jtQjmhrbMva7eQjNVDJdEDhWHF2T4ubeqafnUTEueewGDrX/TLLVpVyU5Def/ChWZDgrEnuMX4g+4jlGFiw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.2";
        hash = "sha512-F46Ir5AWTR9894CZYAAJH1fewZs1tRJ1VRE5PS7sdDD1UmeDASWQcHAt2uBVA8JSSTOQqiojr1xokwSSR/YcHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.2";
        hash = "sha512-Br9R3iEAfP0CGhfkxdxxZwZqF4Wbivu/TQkC2TaQTb9LUX6P+K9Oytjx1ilVgXoyclWPv9aR0dG0Uk+ppq+hvA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-jpr8CwD5Cwl2vUTgl4xj9FcEELZjho2HACniNAXIHJVXTZewFz0S2gqn2is3C2xwc/MBo4F2SW202gVr4V0SjQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.2";
        hash = "sha512-EQ9eXimPClVlGs6fyuoJfxMFzZOl4DUZcGxANknqDpGddoF2VZke8LfLAtgvKTGMlOm0BxX6QwBQxe4f0Po61g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.2";
        hash = "sha512-Fg3H4EbOJDus6sf3/Syq5RVX/C45npjCwrlH6cVllKN3O9N9Esz6gvLkDJ/k3sXqg1a9qExCHuR6K2Ni/wqDtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.2";
        hash = "sha512-tFQXOeDQ0/h5ArqFHYBVNo93xLPJGL1aA/PC5Gg7zoL6dTRhI2lTltED70Km9cKMC6X00Hq1vee6FvOuLs1hHA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-EfCw4g9OheETWmZvwEpCYXG2Xv7ZO9fGHtH+Typ7bcvw/TztkqB9ybMbMvFWujdec3j8lL50mAJb2oAgVcQt0Q==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.2";
        hash = "sha512-rm+2rIw0XKUPfyccDpp7UMjM6IZfHVgK7OePJFU8a1NMeUZvH00haqLpERtRKJ4xghPU2ZfliL0dICbL2AGjhQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.2";
        hash = "sha512-GyRAQXiq2mcespMH8nRnxWKMKeUovUSmRzufrqxB8PyVNehhbcpEDJOon23BpNrO1+YggN6G2eQ2KDNUQCmoXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.2";
        hash = "sha512-y2t/JAwRgRe6PtfSX+gU2oap5/ekL6Fm93LJBNt2awvTpgRtTnsSks0LS+2VebsUAHWnVwCg6NcwuFOPcOu1WQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-j8Q2Qi4Tzv7EO5FvBqVVLtHnV3+40fX8Z9dHkB+jkf+O6ASmDnev1XS4GSOb1peHpJeCauhNxzfrNlBtD2MmyQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.2";
        hash = "sha512-Lyycaaagwj36GD1DNHR2HyiojLtpwAqYJ38k2IPCCyepzkULrvjt2QQ3KpLNikSLjZJuVbpUskNrh4vkoLI5Zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.2";
        hash = "sha512-H54xNMNGYpV2+BUcRcvvVwbXQ7S/Do5iagFGxzFkCPOkTC2MyyvJYSCY4vlRf6O9r76H1xZImABmI7oQSjaraA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.2";
        hash = "sha512-nGU66NCplmHBPWtSoWaeZiK9Z9VJLWC9/PG4fnywm6ZCnbIMHR8nDrMmFvSXO8RGaE8WMqA1BoK9ogVliXYpAQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.2";
        hash = "sha512-KAttjZ45azXcqQZcUquI3CU1YM6xzpUz55lJsD2UnG4eyhEm/1J9zTYregb3K1mbVl6mcJuksUGPspxK+xWsRQ==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.2";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.2";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0b7ddf3f-d43d-49c2-be1d-bf59075d85e7/b1da14023ea7fef1fada6c8898635fbb/aspnetcore-runtime-9.0.2-linux-arm.tar.gz";
        hash = "sha512-VXZ1HqlBREmt0QDLYMkX9yMFIJ3IMezTaYuO9qaeKoAoUBSLM8r1oF0Em+ZrGcdARTHqbs1kPMH9auYReeEkmw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/744cd467-ac89-4656-9633-ed22e3afb35e/4277cdc84219d6515cb14220ddc0bde3/aspnetcore-runtime-9.0.2-linux-arm64.tar.gz";
        hash = "sha512-qpXtOW5QEst4Fdsl8HsZYmG5Hkyi57oHNSiW4as1GpYjL9tpL73h0d3RyRaYc1PS0zgunha9epfOS0EcZCbg9g==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/36ab7b0d-966a-44ce-ad19-bc0d7e835724/a38c1f97ccc9f4ccce58427c830c32fb/aspnetcore-runtime-9.0.2-linux-x64.tar.gz";
        hash = "sha512-SKOd1L7j5xknOk5EBLVW4uWef2Wd70n4l0WuV1/Jdvfr8SHZJjw9AJ22CBl2+CYcqC3jSu9psHdqKP0EhbttOw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5eeaba7e-4140-4e62-b96c-7223293f3bd5/9d8d51b099c3141cdf63597816bd1eb4/aspnetcore-runtime-9.0.2-linux-musl-arm.tar.gz";
        hash = "sha512-+WpmRC99tVjkBJHx3rpCpYtpcoaoxZLyC5sXAGBAVEw83jhR2+nV3Qvk/2hmZXWhCo4SJdyXBpCBpmcmqfD8iw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/07c2a8a7-1b36-4ed3-b8c6-48674ad102e7/ed621013baa55acb77a88013d28ae14d/aspnetcore-runtime-9.0.2-linux-musl-arm64.tar.gz";
        hash = "sha512-XnSHHZEzxSOJVZ6zTugu17j/LumQhX74Dr8rJ8QF4N7hrpUcmoc1UWiQHZis++N71tUW1qC09fSVxYMmJDwGMA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/435eb32e-b24f-4c82-b044-6f4b97e7338f/5e79b00ea13180f349e28f127cf1c26a/aspnetcore-runtime-9.0.2-linux-musl-x64.tar.gz";
        hash = "sha512-/wcOv6ux+ndt9pzm+x5pkAaf9uS3ld0OoO4CjczqonhQD2lcm6a2yDkxDuDZqso5jgeevZCB7DbB4tWmPFvBCQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0e3c0776-3b1b-4e34-8dc5-1f764e435f68/3fc575fd1def4bba8258cdf39cf24e35/aspnetcore-runtime-9.0.2-osx-arm64.tar.gz";
        hash = "sha512-ZvzXoFifsWbYXK69bwjBYEm90MrP0Bqz8ZnEQrmNVPhhDCJaKppvUrxLzhK7qKMAHiNokkCZbGl+K8OgCJVyJg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/80ab707c-4568-4bb3-998d-04b1935648dd/cec09318721d7d5e3cdd64e987a1dd8e/aspnetcore-runtime-9.0.2-osx-x64.tar.gz";
        hash = "sha512-Tjt2vEI+kxK1VEn/FWv2UET1ZkRcQQb8RzFFF2UdTVEMBBix+PF4U7HLwUdpEAuEb0FPgNapzuX5X1pvuFR9mg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.2";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6ad62cc2-7db5-4961-9192-84d50536b636/19e78b86ce8b40becdca65a7b7e8d8df/dotnet-runtime-9.0.2-linux-arm.tar.gz";
        hash = "sha512-vjG3kMilNHwaf7dey7qxbGdf9eY1JWFjEiC5TUF/Ge7QciDVw5cpBRI3BN1r1n0AE4/0JISBXg3vfYrZFqMNlA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3658cac0-6e40-4467-af08-02cf5bc0309c/ad2d0efa6e2bf05fd1078182d232f052/dotnet-runtime-9.0.2-linux-arm64.tar.gz";
        hash = "sha512-RgEz3cJYKiCb2AZzch57mt0rmyln7xUDp9wpvid3hwhwmQ7nVJNR6CB8Pj6E2r7KbVvbvep15ePnSesWvRPn7w==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a15e92d8-e1db-402c-b06d-b6dcf7ad58eb/8c4233bceadcf8f57b40f64aceda69f7/dotnet-runtime-9.0.2-linux-x64.tar.gz";
        hash = "sha512-3EryTV0pg5L9U0kaVsbU49HoXj4pTLSoSMesjw3OKH8R3LJ08Y+V99txlWgThuXGsNmVAICMGz5oucYJejSE1w==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/efa5ec39-7af0-4941-9886-6c37758df9cd/9b0910cf8f0be4645fd7bde1f2665e5c/dotnet-runtime-9.0.2-linux-musl-arm.tar.gz";
        hash = "sha512-OOA9jBL6RSDjEc8tFfssLw4BnHFlsT/L5Y/EaRR0Ps6o4KxNkUOFsUMM+14N89timUJM/czqb/5GmmgeLZ2Ttw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5a74dfdf-3b5d-4e92-bd17-878401c55dd5/a9fcf25e0571144a1cf08b23da3476fc/dotnet-runtime-9.0.2-linux-musl-arm64.tar.gz";
        hash = "sha512-C7DcekOIxbldT+yf58oSc/mvpQICHHPrlG7Sko1tbQg2QUQA9mfv8w2pe4OwT2bTAywjRLslhwB7QAHXW2lqFg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e848109e-b3a7-4496-ae31-345b92345a81/78db157b0850dd7d9ce22c908d53154f/dotnet-runtime-9.0.2-linux-musl-x64.tar.gz";
        hash = "sha512-3xFu+bf2txe3x/BX6CbJ4fHtDXQ/prJukin8NuUAq4NNGa4atV68KLHJuMtKf0HGLt0Iwt0s3LbpEt7+ooEP+w==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4e559996-ff59-4cdb-8a91-e6c7d7235f4e/e5766287ef607672cc47be8119afc28a/dotnet-runtime-9.0.2-osx-arm64.tar.gz";
        hash = "sha512-WtiQMRYHpfsU+aZBA6zXY4V4Hkt1CFqOdV2kdP/B1Qcwu4Bk6Lr7EXr9udBM6svVhFJTnx4OY74LlzHhn9ZRVg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b5a5d3a4-2054-499f-99e2-cf64bbc7ad24/bf987a5f19a84196621b725b9e41b332/dotnet-runtime-9.0.2-osx-x64.tar.gz";
        hash = "sha512-q+B1LzQ3zg4kFdH3CHm2sGLf2lkSjvW5bblGY5tQalTKyBhFtnddGQFNUicavrjfqs/reDRSuY9mJlxe+xs7VQ==";
      };
    };
  };

  sdk_9_0_2xx = buildNetSdk {
    version = "9.0.200";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3dde7d92-2a9d-44a5-8e83-6ef57d976c93/dddb3f71a8145f2729c38570694f95c3/dotnet-sdk-9.0.200-linux-arm.tar.gz";
        hash = "sha512-R2qaaGryNEguqZ71P9Gjtr1l5O9fJOseLpS2DxRue357mVGaZqiWg2aC5wIAcCegThDt6Ff8RUDDuuVrFss3gA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b94570d9-8cb1-4672-be62-4acaa8675749/2697b4ae3923b16e72f6443f30333f5d/dotnet-sdk-9.0.200-linux-arm64.tar.gz";
        hash = "sha512-wtGGRCQ9Z9EDRxcT8Om6ZZ3wwNXgmL1EExBBjdA3mNalqFOdp8jMMg1XCFwZPHU/94vf+Kl6l8UfUAQzU4+3Ig==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3606de37-1325-4f5f-bbe9-1bc44b3c1c7f/91872629e9f0c205cace9c462d5e89a4/dotnet-sdk-9.0.200-linux-x64.tar.gz";
        hash = "sha512-GvXzpERBmz9c+ZywPudAciciR4Im0K/yetQbHRHmnXNJfiXAfvBqbfnnP7D73EubrKmszslWVNnue+TVpcOsIw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f65430d6-4ddf-4ed4-a91c-025933457f61/8e0766a17389dd840585ddc440431e19/dotnet-sdk-9.0.200-linux-musl-arm.tar.gz";
        hash = "sha512-QpftO08RLh1kpmF8uWGRv7Tr9qX70Bx13mwFkolxc/ARrvPZvn5hc44MjOi6GBWwbyjgwlHIQPLg3iYw02YWyg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/071e3ccf-eb10-4658-814b-c86dc60525ee/2ef91c84593fb6f465082ee069502085/dotnet-sdk-9.0.200-linux-musl-arm64.tar.gz";
        hash = "sha512-8acIB+Cite4nK91xRTWi+j0xu4wiFrQ8FRpyyzZPZKb4k1kLruvH37K3j/UOS6EcPkyt8Rx1dEQE/vq9x/8I2w==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/625fe095-f8b3-4666-a4ab-b44931f482bf/bbc206404c3e402749523e37063931b3/dotnet-sdk-9.0.200-linux-musl-x64.tar.gz";
        hash = "sha512-lrAy1SCag46XUiUolj4ulYn4OE3/QpLlZwMLDaCEkQSlfNbQ8F5ft+d4dzD0fGESoBTfF8dgEIZPVcEQqXHyFg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/be46fe4d-4225-4681-a301-8d2bd5c2e044/362014a73e57d02b9ffce618c5ab46e9/dotnet-sdk-9.0.200-osx-arm64.tar.gz";
        hash = "sha512-pF1ab+XwRunNCkSCpB8IhIIpAxNLzS8l+s5x4TInSdrMUyIc7iH4FMYXEybaD2T0IgTr159jOjvRB1wE+nPRvA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9983e36c-5e9f-4895-8f56-1d0a61cfa9cf/945b1788d8624457b631a383d55f109b/dotnet-sdk-9.0.200-osx-x64.tar.gz";
        hash = "sha512-84pkHRfe3wviTHIcxPeHhAUM1RhPtcxsBMSy5vdgLFX8WjyA3PKh317Fmu2tQpR3IFEPB7KzxZthhbka/yAQrg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.103";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c2cb3c08-be1a-4b0f-95f3-3c2b2c2371fb/04c3b5830bb78065424666956d65a503/dotnet-sdk-9.0.103-linux-arm.tar.gz";
        hash = "sha512-m53bvYoJDuePQFdqyfPaylpoRe45RIsQw7tRsrT55+CpebagDDHaCPPmhgH6d6aHpVbQecGdUyruTX8lvJ8TyQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/226328f5-ac73-4daa-99dc-04961042c422/18787af4ca8bd7d646534c559e4a3c75/dotnet-sdk-9.0.103-linux-arm64.tar.gz";
        hash = "sha512-MrVJTndokIbo1bk2Q05Oh6jYgDn3fDOB2WWSdX59cW9Y3hAD/kHH7zogiTZqMgUYf1bXM9X50vFQXYOxwW06Cw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/053d1161-da60-4c43-bcf4-cfb91d3d3201/18cad0308294c91e3ca9913a33cb4371/dotnet-sdk-9.0.103-linux-x64.tar.gz";
        hash = "sha512-r9pIc2XPLQgvHcRi/wFgfq4QZX3oKBxTxOh3XfcvXtWzG0J+qK/QkXiG5zsQSiXbTGB+BRD4vjp2HelEXXl7dQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/63a41de4-93be-4cbd-ac13-93d1feec6a30/a6bb2018d1a952daadf70852064686c9/dotnet-sdk-9.0.103-linux-musl-arm.tar.gz";
        hash = "sha512-ZjwzUe2w04sl+oVL4JKiz3tv79Vo9NdFj/QHQLljdgU5C0ikrNuzVkDUDcnv5mam7ilH8Q/pyaFrl0P9dbzw0A==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bac1de02-acf7-442c-9caa-5267f24060c0/e94ab7e0015a34f7a76d33d3d0955fbf/dotnet-sdk-9.0.103-linux-musl-arm64.tar.gz";
        hash = "sha512-vMUBmDH5Y22BqHNp4c9W5w3FLCmT62RGj2IClimmEDM7I8IGLj+TZHvry9994qrvp+nJbW6W7BYeOnRXZq4Qnw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0211b6cf-e6b2-4034-b2a4-f47828046fe3/fcbc490417d2ea0114a74aafbb46b92b/dotnet-sdk-9.0.103-linux-musl-x64.tar.gz";
        hash = "sha512-rE4hFvmZmfJJwpDpqHxij2I29Zxl63Zyu7SEzBFZv3OclYXa2AtQ/3JzNeS/Ym4XWRMVaxOig/F12uf2qWWlQg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c54a9a42-e212-42ce-b00e-ac352d2fc848/3cbf76fac85c39e1eb8ba4a4bd9fcd55/dotnet-sdk-9.0.103-osx-arm64.tar.gz";
        hash = "sha512-UvKdGPd4m8U9FbDh6WuDuIEerss+tgNd+5Ti0vK7GgEdCLRpEoBaKGDFdJE60zj18ICK1mMQ3YfPeBY8OwJZJQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7306a1d9-153d-4417-9d94-950e2d2d0426/fa4dfb44bce429d39ebbc916e949c3cf/dotnet-sdk-9.0.103-osx-x64.tar.gz";
        hash = "sha512-es76FxqsumY1idXJ6tCAqAjuYGlreJzomv+I4GJvIIXTKhmBVKfslKjNXNJy9wvVfhmYGbPsiZl+pS48D2uW8A==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_2xx;
}
