{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (go-live)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-rc.2.26504.105";
      hash = "sha512-jxEYa7j7K3jdMa0oT9a02/uJxtRkrICF9DtCs812I0nQh0bzL2iYubfMzQnOfk+njeghwVBeyvPWVKxUW+UEYw==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-rc.2.26504.105";
      hash = "sha512-bMGXx36yTcOIcRccd10UKDFiKT+oGbhv7O2x21TOGk+qFZNifDZ8Bf/LcCS3T7+JpA6LyFfhycIP1T097uCTIQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-rc.2.26504.105";
      hash = "sha512-h1BaL3BsuIasSJ3C5wpmvkmTeUnQLldvfMai872E9d2IQSjsx78SHWlyiYmEsvtEei0n2EqJn4hjWia3xyFOPw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-rc.2.26504.105";
      hash = "sha512-GQj3+oSv9KyVTQchR5QvE5+YiTwefivhR7Ug02xba//nyn2MfFP/zY+jGYgzn8RQQTAX1TRwBx8fVW4BMr5QHQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-rc.2.26504.105";
      hash = "sha512-O7jZ+dUrugPLv4HOHhNIkOvFiXlDfwtSDWq7dDGHMzsOdAuNG64RBQCEvLEaIxfpWDj/nr5imEL/8b9aA4oBQg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-rc.2.26504.105";
      hash = "sha512-C33EHQmEOKqMVN2XjbYvnOP3Es6J1bORvWJizO/qBZvryXrQS0ireuHS8P2rxkqGlLsvzZTLWrtXtIYraNem4Q==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-XxQwTXiZzBn7X8B3M/lAfl4PC/0gYfp0bdWPYsM3n+sjm3JGCutXNu7v+q6c5v24M3mS8vY6edxHD25w9+3AJA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-JzEZRNFdYLktEHRK3ypD2kMavoGQ3bZMHbYr6GOMuX9Gg0GyzA4c/3gfpBIybGdEaJ23TPeeVJnCYCsBGky8Aw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-hTMpYTm3X/Idl8bFlFDKRooegyhzCqNPLkYbn4Tq99s96eUoWtb9i+OzlajfniREfdYFICNRLgmulyjSP/bXFQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-lQDa/N2n9fET92E6GZTep4l87dfPOk+Ym84E8HJ8uUbjA9o0DB0I7SUVTSy9gfANjkWXRr6M9MeLoKOPCw+OIg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-R+QLUJqwo7idy5D0NAoP9uRfPWtEsELbbKCHLfmjVnoDyD2uOAP3J9X9ygVTGzulvXtxn7Gl2t6vd0pF60NMMQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-LrtFjdn8P2vh37okmzsUR+tL+MTVkNbzacPlm3CWgtZp2t7efnU+gsHJYPec5yenLao8G/mOYid37wM6/xFNMw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-h3Xl0kR88iOyLKNI3Sye3TYNojpIXvCpTHV1pHIqux0ybiL0aTEPgsfXyQ3gM0Kh6da4OtU34VR6yqm26NtUYg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-QC+TyPu1XCPDKgathTNXtwCbfx6INxnS/QSrDFx17d0DalxDSLGY6UoMsn3Fvhab/ngqe+wi9zNKzcKI9SiLRQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-HgIQdVjy725GEujmnfuQXTl+/7Nqyw5HLdtNWRUmNbiSSP8K3qe4QKhB2qyHUlTifeGoNBJQxnCASGIE2c5h1A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-eL7g1hsNcbfi9QAxXLV66DGVdekg1jiNbuh0MC/UrUNxYIPUvAN0e2FstI7SVidQCtaclBrMlCrNQyjjbk1jhg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-sVWv6e4um0YuMxn5Ow9ipuycsdpYQJlvzqg6FtOMrp44YjOku02WRdPEBuOno/ovhCeb+zpIdx22OATrDfJmnw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-9GYuRIHvgOLeVzDihNGmTcVFc1BhQJyowM6Oju6AiE38VeJIdzl7GU7ezcTZlVvh2wJTN21jJgEaYjaezSqBng==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-kSjWH5TR6G9p7bMO6x2R1UAr3f7HfCQNPzpU1ZnVL72BSGPNNx5Y0Mo1UEvpDMZ3cRJ3N4dGorUW9WlTagf27A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-yLqI19MBlNRmSyBbSXVJTvLpzIoEj/mm2OlteqxjCjfsQXjiZp/pFm6/Sta+2OAq1xGmfGd0Vw/NN4qiZVlPnQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-m128r9VtNe1u9GueWKP1yvdLq1z18rD5fynfvCfxbnIVT6kdrr1eZGE1R5jJduEvZyG5mz9m7/wLgcD5lbx2Kw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-gKO+JNzjGPLdIsYkXd6/aLXSwOXa7QVqMnjAGQzzpRrCViX4eOA9AnhauEvpItGKg79nWLBtgVC7Ca0ccKMDnQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-cSDoyC5rH5db5G55jtVpGSJSV1kwBNNSng89XaqHIBzXl9BpsNTQ/jpeUd8YbG001ZlJP+oM5J3UpBoogm2h6Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-xA0CXQq6PQEfblPZSm5D99wN7t2aiS/W8VQXCN+zDMtT8RtXFVY1ciHqcXSP7OtIRwAS80hBPABHIaoyRuB47A==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-akSxcWoynMnbtF+Q0nIqxkyw/paS3BWqP6nCMJQDQD8QTQTM9JT2vX1rFDEyiv6V/lxkimnLS23tnq6GF+UJ0A==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-IrqxSBHQ0VhHD/8jiUpXY2BaX+Ll3GdXG1ta9pM1ioDb0wkiq44Z/+PdzerFw+MSlq5OSyUJ9nQt4Zk8jddXsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-+4LHr8JN7ynqi1hQZYMiNbtPOjcn8WoP2SGHifN2YCghxZq0NJw3k0jUxoPVjbWSGplnGmJwYoH9itXfWSoxIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-XRDzMcAAmXtrRko4FiH5pwYDo8kGPTcbkr3ZbdEEa9N7r14eFSYmJ75WCGq9eb54kkm1ajXSa7K5/HZfJ+ElSw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-+DK0ve2M4IRL0GP3lMkWxCDYSNKGrSWb4dglgaNEHWL6UAYuq1/dUQFsRIZfVMSZZIQoCE8PeotZAlA3tZBcAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-OCe0U4g+UnMYeE4QcQvxmj/9e8ongElr0Ds7H19p3EPq4Vlc5yAsp4Flx2Ux0H9eSYeOZgT+uQGOfvavbXnn5A==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-2hsEUJ4MQt4ufogSq7iLu9gm5SvehdTGlW3oDuYSXj/1hCGXxsqonRBs9kzHq4JNIYTl0eXYwo1N0pjrLehlIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-SDBvQ2FJkLKqS4G91w6S8bHdaVr2Mo6Ko3jEluGDikIiyjjIBnF+DmvkeOV1m3rOBFWrMVzGctsiDfF00lMFmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-uTSLzhuvhWslzfmO6uSUNDCDKGLVCfbFJbh7TygL+4T5x6askggK6DFLZCUzdAKqtOL4v4jK/3pEauW1vMIezg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-t7oBd84N6ZoAftuNBrEwRBnDjTPCuufpq+KXsbh0ltoEuYj7bQMx12xr6E9UTTsxM9gISH7fN//0lggr1c4iVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-zFcF6DwKdH+Z1SLTJT+NB19NkWsVawVNhsXTLlRyqoM8uAWcS2IJ3JRlS4w+OHFCcVF7Kq7cgw813yNmfu8jsQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-/9Ae+bVRuAZYG7q1sqhYBOocbLzJTvieyh1gDUjTAdNYIsJr+MphEszes1aKsVvkMW4jNO3+vGIjkMpbxuLs0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-wqWQYurvaq0htkknYblNKL+xy/nzVzV9UYAIyuFUVf35pK0fcuZcHAkeGVqqDmPSywDxaC6bSoJpp9miwbtbYQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-rWOxzM8IuQmToVJ+8uA7NKyEeNf8rAcgy5auxizgNG++HLkomeJexo/wCBZIgnU9zJZVZy0qVHkE6tmKC1M26Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-FmhP3ArsHYHeEmJ2C2HlDZXsIaWDokZMkeifTL0cPQQc+h2/4SRjQz4/E/9Dnz3k5kYBGU3cKXHVTqjnxr6U1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-I/4Y9EbjVCQ+wT/L5sxCtUjVgFyJwBgrMm/cYMy2uepGXG5ELHCwLVQG0Ro2hCsfFpVbUf/pQDFrUiacP/vwKA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-QwUTSe4cEJ9jJ6nThwmJ++EZh+6tK1q/KLsaiE1t3JiPvBdxc/ak0n0037rjMaNh6ZiikThv7Y7SzScm6urU5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-mHwpJ8jV1POU97SGF6h/MSZ17U7/xhWl4aZo+nfOX7lnqUmIUvfD8+FU7WiTg8SAqUYbseNfT94d2OFHNdTfUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-/C7kDewTIZgPdJ/qXRrNgm1t7EhyR0O8yK3ZTVqaCJmhl5uKmklMtmraFSa8E3sEj801IQ7qTNjK2hxEUEIXOg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-3BJRgwgQz3jUK3xwPVh+GNkh9lQFMYSH7iyqfYj/KFRgPoLmHhegmLFPzvCDdkXyoiyxxercLWFHDN68ssTt8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-jhBPlv9qbAW26EQh5pp8BmJ3wS+1VhkBdBvnTWqGUYclNSYyUquI7D+J5o+ev/MZFa4NkO75Jr2X/pEyBjQ1iA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-wQJnL2FJx3NdT+HyPlq5uiguDk5R5wajV0p3Xmmc1Hic/0UleVfEfxAcb5ywpsrfSb9m37nlnBdaqP9nK4XaHw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-r+YXyFjVbKgKsLN0oj4IJGLum+Nsctk3clpIDLEGbZm0DCBPDLhfwHWvCOmthyNf4Ac2lkpL+1qoXVEu5cEQNg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-Uus0q98tUOcahR2PL2t2A49HmvLZRDlNEm8j/SYMEyeFVksHzmDD4TrZtikh5RbjXwa1FSqzm/dAxnWTlgCKXg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-3JxkDpnrHRj7ArxdhezoxteW6j4LWAekPbAn9LfcNiRWhFWiy+LZT9DuAg9v6eQQ916u/5dC+lWyj8Bl9DBiMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-YOl5tyuGZgQu6OdP17ZU1OFDpwQgkdULogSXf6ybl5+aAp9eM5WDHaf3ZOl06U2Wr61ry7n/EVkrk3vIK4TngQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-fCzZ2CazY9kvcDhVmh3Q6o/wveQ59shkWPxLmFLxCBz4icx8p+JJY8erFrqRvHkPE1tCmh0gKX273OR3pc0F+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-VyqeAcX7IRbHQqFOOIxOyNX1MnMeyeQ8CWsFmkQpIrsyZ/Hp8XFxoZhEIDv83ly+u0ZCw39X/Ax709vSn8a6lA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-8zeY0kGUkywon7fYGQjd+D94TX8qGwbeFqmpY+cyv9gfLSZxB6tyuWzEwebXGTosloXRX4Z62rx+tGkssvRZ9Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-fX4yaTMuZ9qrAs9X8MhoKwkndoZuM2Tk/wZmlYaDonbz5qHMStjG22SzQhcEQRB3fuKgN2Tl9/spZGM6JBskuQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-jv2uE2waq0k4SaaUfWyAvGBPzu8Ya5gZ07Ou+6V2XrOWUS9eCjc8s77ptkAbFT/2C/Oj9xeiuGkbaoMg9PCmuw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-A2mytG36vwyQ1bOCYUIvKZLrcDq1QKUvQcJpDZ7l4Vp3lQBF6kIOlY5N+3n0LsdX/XZfGnvk4RWZ8Brn9UJmZw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-DMeiUvmrqrSs60cMKH4VC1/WvU6tGiyZKQHiXWm2KxInYiDwCh2defePaqRZHwvB8Z1ccglKSn/NlOsXuIulYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-IA3i9Hj2x8gKHX8VjzoQa/+65K5KH/EzcZ9Wi9QI+vBJ6pTwq1fLV6+Cj8g/OB7ZBn1zlZRRqSOOLX6xlk2GyQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-aJo0Oz7fCT2HcYdkkgtRDWkqlTJtkfYVvbPQ4yeyORHo/T+/YCCXs0LIoPUAzBJQqiU89kzCZJHPO7mLmcYqdQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-Hyj3r6GnXAhcnaO0G6jpctmtVmhelXrMGuFzH+dGCEqd18nljqma2jUH7114EE5LYRiseKSjTjek6YHoci6k3Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-KdeE9r1Z5Ycg5/Jlzk01WmFn19bxi2RCVkay/AkwmcJwcQn+SAT+W5AID3MSj47ufe19KMzoPxWeUMyaZWPDcA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-KM7081/iOdLX2Cnmhnb7sE4FGtn6YayFXZaQ/N9CYBl5kkLs7J6nhxFcp9uFPz+cdWRBQAgf8qrT2hYktbrdfw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-lXX3Jk42asq7OI3w2Kmn3bgvHumEdHt+1UCKOunXPnYRlP5iHGkeUHWJSZoFIUCsSrDoxmzFERJZbwQ3Q1U7ag==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-95pdkYxud+GfdqzZNZjr80EfUKaR6L50T6e7Y6cLaXAYfBpPgUAwkMa+0vQpPep8PFhCydXsU3E2h6Jf17INAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-d+pmJf1qwYIefBy8OagZjqRvlViWGRKXHomd5X4E0QQHAiFogVy3k10/4h9Z7DoNzXQcfQpDk1HqKaHq5r7W/A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-PTIrQTTQ/EeFEbIUt5U53PunlN9tmKIuqbEuc/sw1q26bLOvVQwDH72q+/P5LGLXhSw1g2PCvoOf4cpqBOwgEw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-IxiChLmDUzN4peLCSzyUUGKOW2CEJU7uhEC09dWtcWOPPFc0JQ+WNVzI81ofObn0TV9FLQiNsN3oz6AKG7EX/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-lQQeg6JC0jp6mAXd/RCRTrR0hsZ6DII0Zuwe/INfPoBvfNQpub30eNxEBGP8WaqXZUxAqx2KR7l3kR5stMEWcQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-q0Six7eJWkCBH8+bn1ZJtqlFLw+ACUxbZbz0uFjsG4Du58HOp7dxq3CAnJTiRiz2yD9l8m5ttHWbhDx2megv5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-/uJXwGUiAZ7ZsvcjBfx9tTRZFHBVlUfnpiyGqGeyHDVIwyQkfajyBM8a4WkTnll7tku/96ZfOXQsLZOqRH64iw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-mzd/NwhuUsTjuHkyiE7/ny52owY1DIcOnZCrFgjJipssz5VFOvdMRAAvl5ll/FKr9nHFiamrG5C4DywYY32y2w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-7IZhKQYTQgIf62BpGE8+LmWnecMZRpoGFSmKkQcvRf6o9kDPpn6RahdkbWGe9DQC6DJxAnHjDMiPd2RVyB7OKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-/+KC1rM7CnATrlz/4y7czPObhd5Aj0B5Va0K7nR9xkybXafKxVtxJtOsJt4CT4geivb91LHFjuKKphTNu2p2Sg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-SqVHbBd2Sm5jHFf1Eon+1fcgOp2BCZ3o9dGniDThoAUN8GEhfZb3aEatPIPiYW2xOthfYov62cNJx6zGQ04f4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-Qd/66/10oStFGXrBlcie6aW9D7q7ek1hnuMdgYxCgX+h9EZRdU+BT/zAf8clcvUii6DMg4GWJ80DEz0/oMmqAQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-h44SIpKTuwjhZ8FZNkIbSE/vxk92YSehu/MUui0x5lxOGDe2oKXdNY/GLZtR6Vt6xdft+i2VDlwEdRNJnMYCMQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-dM0Fen9oFpD3GxYBsJ8ZRw/sB1x0lwHqGsqtFsYDtpmlXvLDTlZqhSV4mzf4iBKas0ziD1K2MqThzTpiXsGWhQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-WvrTcf1PKt2rPDvRl6CVij7bfe2d5Vsm2oQH5e3RGjc4BtQAhVCEzY3FxiEjMKLMNv3J0sGdX86/vML+ZdVmNA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-EoV1UcqcM59Jw7ibru/P1Yw74UjVNg4KtW0uGaHmgF7t/kHRqJjnQvaQyu1scekxIWu4W2P6HUlPjvGYUiOhJA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-ANKAaaWsA/Nsg3DudjiWorvEGufHn6F3r8glAQ4H2IArcR6zEgYTexaAKN/o409XOHqum7iWMzy4xR9kdtXCcA==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-rc.2";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-rc.2.26504.105";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-linux-arm.tar.gz";
        hash = "sha512-wnYJxAVqoNtOAT8qk3TpW3S2dSD95ciqnIrBjUcquahTYoWEKa8XTi+U3tUxHLMFIRJkqSJkNEjBEM3/BI+xAA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-linux-arm64.tar.gz";
        hash = "sha512-dumAYGoW7cogTNvmgmIgWx5BNI/onZZOqGKj29gtWrAXvbqWvoYlzJG+cfUCvahQ5A29Rv3Y+ND6G/a6GJkRFA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-linux-x64.tar.gz";
        hash = "sha512-IabiG/64wE0yhKOooRhP9I/k8flcn7MgNrbmErRSnx1d+ndlBlck5dm/BZl531q405M4PPZFe3O80afpG9oqwQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-linux-musl-arm.tar.gz";
        hash = "sha512-1ZQOJvo8zQKDqDKCEs41hzCfwEm4ImJNRCdk8tROGmhY2OvfL2M4PYVvStEaccvrHjO7l37Ee1HBuHLfkOb2Yg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-linux-musl-arm64.tar.gz";
        hash = "sha512-QMH9/4vIj9Sd+YFkfv+/s7Zuc3WzUP7QKjIRK+2VoO+0Hf+pMq07QdAI/ocGsDxLnsI85UaRhyNLPVHPi5Yy8Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-linux-musl-x64.tar.gz";
        hash = "sha512-mKSSJGQKAW09ja9K42Uc43MWBDfS0sfgheTRo6ugbQikUir7NT7BQjJ5OzDF9gsxOv1OYV+IBdgQwxUXKFl4DQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-osx-arm64.tar.gz";
        hash = "sha512-5S6huMkQOxP+uiX6AWb+H9p5a7c5D3ZLidqaJLobqToam1XpXf6IwDjIP08T/37E4Pyrv3tTbi5JKNMEpyKJfg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-osx-x64.tar.gz";
        hash = "sha512-cHdPFVSLALT9TWfZwF2HClHYVkfBz61KtEELbZ89MdRV2py6QSu38Y38cb18onRHxDYRZV3bIeShPUONhEXK6w==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-win-arm64.tar.gz";
        hash = "sha512-SACVtpmlD2GVq3cJNegUt5mWHn6M+HjX6tKGv8IISI8I0opS45ejYlTiXQwEGEhZ+FGZ3SNJdVymzIk1XmQpPg==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-win-x64.tar.gz";
        hash = "sha512-QMrQTmc8Cff6HLKylql3/phW0EpHjw7O8MjoxqKnsv97RdtYE1bRGGoUeFSDYR0J6QZmzrq3UKHJewSEnKo6iw==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-win-x86.tar.gz";
        hash = "sha512-bV7M0ED2Uilb62VMIrUjUM7qhHfInJd4+u5WUtkLLmxVsh1WkcJcix39RioysWSrhaYNeM4HQ6Tpn/QJl1S8TQ==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-rc.2.26504.105";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-linux-arm.tar.gz";
        hash = "sha512-90wVMyo68I1CQomG0atgUPc/AanQmuJB11dc8RwoK7crz+ZX+cjfWo1v7yrHLD0EWUrIZGOZLqQbLUB51PS7hg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-linux-arm64.tar.gz";
        hash = "sha512-5xy/yQLxZZjZ4cV/XUI5qAPdri0IZ/D59dped1kDiLG7JBTVhuzmUC6Lf9G75iVwwJAXOUjnGj9nfNlwpX+hQw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-linux-x64.tar.gz";
        hash = "sha512-WduIE0/dkBL8bEP0AYGJ0z8/88yHFyL4piBddfEU8tn1vHFgU2GIjKD3SRGs4G+X+bQZ7rMW1SC+DCQQMSM5IA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-linux-musl-arm.tar.gz";
        hash = "sha512-a2E++zGmSXAI57HCjeFkg4eHWTJRyW5/mYB1qluyHGf9bySZf2550LKZx2VjsxajUTNpN/gLBx1EBroHNNbI1Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-linux-musl-arm64.tar.gz";
        hash = "sha512-nj3g1xRP9bzct79lHMt4HcpuwIp4aLTZQZZ8unTmbEyyes+pnqMzJaC5YaVSf7m5bOTyw1AeJ6JyubfqCUBPPA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-linux-musl-x64.tar.gz";
        hash = "sha512-E01wbUVCQ9z+A6li8r6raNWPPq8W5ft/tIXE+RJZaC5crFhaNe9DiuFnWPLCbZgJGDYO8pcHC9RRtfbjAzAUJg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-osx-arm64.tar.gz";
        hash = "sha512-5Qd6lrPk4NlBn1il1ju5bodKFDpzEPbjLP/wNMJHF4uMMjbqpZSY/+3SLz/R4wPRgoCvpj9VGLMOwNhz+0F0uQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-osx-x64.tar.gz";
        hash = "sha512-IE3iFZufRFwQwwFQrgompmfvihyyvMl8UvCo+ZDi7fJ9SCngCOFD6xlD1Afthbq7oT3b/FEZqik+O9zpC+hKfg==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-win-arm64.tar.gz";
        hash = "sha512-rTz8SWHZaGvs0e8fLM+4fBGTr16mRTWULZPh7RQUuvYcanG1kIlTxjU8EXg4wcuEGBN5zT6OyZpAH1PuDzGj3A==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-win-x64.tar.gz";
        hash = "sha512-VR599badEb1NM+Qw+F9o6EUId7rZoDuEWjYomxOSSKaCwioyz6D2gRh2xxL2ds92Gh2a1uiXJ9a56JKbJxlA0A==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-win-x86.tar.gz";
        hash = "sha512-79kP+j0TpGSOF9ffSIRQRzcNANhVanrK6SVeIZQ9gW1FAK57sKQD6h/3Ir501FqiSrmmoKBGE+uu1zAg9vLNAg==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-rc.2.26504.105";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-linux-arm.tar.gz";
        hash = "sha512-/G6rpb1sJwSWvWEaalyl6/6xev21T3bjDzixDaG2Xoh+8RIX/J1PUWuBXbNryIHt212dhovcxknBx6zcSyuddw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-linux-arm64.tar.gz";
        hash = "sha512-LrrqJjuUKK8g+X/YtTeeEkjyFAHoNFtSkDh/9d7tqEZkOU2i+exIBFMFbDB+2KToa/Z1IZ6QSm4dBrFWUlqpWA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-linux-x64.tar.gz";
        hash = "sha512-VOlGMzkzfO9o9FXpfa2sCp4bSUFqOxVQS1dxRLJK5LTu1Oe6O6xQdlC2Ht9wTpd7RifTgE9MJojMW9abTy7s3Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-linux-musl-arm.tar.gz";
        hash = "sha512-fKgF58jBqDwMDu0pqQVh9REv2lG08SJPUB6hF/HVJy8/jih0dgj+j5MS4bOtMS1xWVQxTcZR4ILfOnlLqtYSMg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-linux-musl-arm64.tar.gz";
        hash = "sha512-UFSAb0lsMzhiGiopyfOwYdkwq5vK27DJMzRYgJJxG2rTah/CMJweiOvwHDmPgBTsDaLt+BWNO3d2ZW9gtfrcSw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-linux-musl-x64.tar.gz";
        hash = "sha512-o6lW5E9fm3vg1UeqvK6rSSgxoGqu5c+xWVIIShI/6pVgNkkB/ZRby062XqYlE2hlLnYzZSC7mIrp2k/+DkpRjA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-osx-arm64.tar.gz";
        hash = "sha512-bnRzWfLXJGKmLwItwtbzc8zfhLO9wR8RCxeXuEatE9M85yvoo+GeUN2z+j7vyMlOZdY8CwPuGH+i3BgynRp92w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-osx-x64.tar.gz";
        hash = "sha512-VVKxeHM8BqReKT7iYaMlbc04xaUwKR1Pn3Lj7Kv+DEhMyvKzvA9sexeAQj0z4TTgSLhm4iPbcaetTwx7KpV2EA==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-win-arm64.tar.gz";
        hash = "sha512-37/M12KZu9QmDoPSoF+JRifPxEg597LRHBYON5MMgy2IlmfAxW/PxBDINgG+Jx7p2baOva3JkXmK2hknWb7iog==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-win-x64.tar.gz";
        hash = "sha512-gJlvuCHe2Y7AQ56ozsnfjZocj8OMpJqCjKUKz8NCrIzS9BLxFqZk9fKF+gYRi0YjW8NM4DS+MRKlajuuBAbOBg==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-win-x86.tar.gz";
        hash = "sha512-A4pYC++f4Xfkr+uTOUxBySQ764EHnE5ivuEWSjCRagX4tefPViYKIc05lGGVFntfDYpJLJ7T1yw34Ohei5ZNQw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
