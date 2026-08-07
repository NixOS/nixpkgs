{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-preview.6.26359.118";
      hash = "sha512-dFwTN/6WUadwxP7F5FtHcr0qgJ8s+ueRqalhr4MFPrlPlilLIa4Z9h8au6wcIUmuPTQGlKaIjKI70YmzfR/sNw==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-preview.6.26359.118";
      hash = "sha512-01WtjkZwDOqPnfw2Vhkt8gqmEss0dRV5qOmU9M1vQA+cvT8zPljADfV9HL4RmWGeKS+rrnc/hQMimCnn2ZVvBQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-preview.6.26359.118";
      hash = "sha512-R4S1r+/g2Vd4C1ECLFfjWMSDrWAxE3uZ1thXVK2CJYw58RR1GX49wjvXseQU2Ll0pj+lxcwJsaU1JyTI/WOPOg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-preview.6.26359.118";
      hash = "sha512-0K5AWYhlCIo5lbk+k48Uau+hyd0qqfss6G2TKlj3hHo5sazrIVrS68Yrwvp7rk1VUHgR1bVq0arOrND6bcitxA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-preview.6.26359.118";
      hash = "sha512-Gmt0EwMKaHgrrqxnwW+swwi8685MQ/tNvGunpFwv0H3ITadoMmJUFLpyszuTTE60bXNzCVuZFeBJLDKVEB0NgA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.6.26359.118";
      hash = "sha512-B5Y8ygE5httUWnVlWEi9xuJ6cs71685MADt6RAsHEtqIpBdXf+xGUEFa2gBZNw2nELcT9DBk49Nur59EfwqMAA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-+u7qYZ+7Q8La+067O1yn/rdTqLHMoWulLIrh2OitueTda6fnMaUBxr5GlkPkYq+79tZEb4N6n8zopMaVppv2tg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-cSG1btngs34itEXMyyDiYKlHb0J4rbvQhZlZ/IgLNUKBUaPceffyTdoUqjE6GWYrsEtHa/aE9V0IVekd72QXIw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-I2JKKTGSz9bPqMJHUv+uUe7GTxvnLazVfVIjAuAVukqsU7t+xqPrx1eUVU20u86BnZdfY598uQPSUbBoYTCDIA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-mrIfT7taDEhckyX8l3cQ/8mf6ZegfNalRVKrDEbPBpRUmL13NliOqJp/iRZ0BnykLnwiZ8QyfLT3ewns8kksEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-XKOCSIb98OQ9JNzA37ns6mwx9KVFWvMykpyvOqlTKIBPR4m81RWZlpIn9rhCJJCm94FeaRE0m6Ecov/5Kq0duw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-yD2u7QnV4wff9hEA0AdWoSL0qkxs8sWkd7HA2h8lDS0xW4FNb5oj4a/Pk9MwwkRMjHrEUtwFL7ZpnXLC096HSw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-SzAMIzBsq0/ouHi+81P5d1KfETq9p9juOMNos363xAQLtLTzAUvn2QhTrJwvmx9eolAOYIn2edXHWYF0cy3tAQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-V5jbaeYMf8ZVDuPOKgBDMoxbvBXYAb0onNaWQfPytL3hkeVXwLF3UU6kpZUWBVkdxVk5DD8p5ur3PwQabGc6CQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-h9yEU2Ox8A7N1i2+JmrgES4iW6Rp3X8YEpjecpHJEbywlcSXPxtaj9pqh99B7zuTIDPT2AjVX/8HiasbCBA4CQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-0qUlJwrnxbf9kxW3Wcn5YsOlnl7a56kMJ7NXVKRIc0yI+0QWQ0s8w9Ig819MJWUdAU/zL4b/D8v4XaRKZ9Ml4g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-2D/A4vi4A6Ta2TImdii/FfZ+cbZSP9UEp3os3w6o6Xcg465hL1Dsbx84oYpnY9Uv1rmdS6OOP99YkJ+SFnC2/A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-rySJl4yhQeHPThLjnAQZ74kB/9VvzMXrTnTb1WDDI5K6MoKDWUbQwYYG5RcDfznMnPEFEaxtJpD1C5ePqS9DSw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-xTY6ZHgx/10Vw/qfXk/wd5Pbrh0LSaszrGCcwHNCoxDx10JRBs0sSU/652/CJiz9j9Wkfse9tfFbsRMoX6d+4Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-IqSlMjvUVbFj5DxRkVI/7yILt2QC4MS6wWIkGtaG6Ovfd/++pR7Jo3Ts8UYrXcexqo22mzPCD0IFvtVrhvYy8g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-JxnTOZFWOzF/71Ah3sRPo1KdOGLcow73aKROaWyKHIeprLCtjCBUG/s9tAqPI9qhl4fO98nyl14G/U2bMVv8WA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-O7JBnSXTUXzpQqRQ9mZSZM9qPOw2EqzrK9OiqkFJjwgZ3OsXJLD5ze5N1I9pz4/dmMDmzkxJDDzrriPTJF4hEg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-8vdE2EPCohoCaPPWq7R+GfoFib03Q/BRUDFrGFTu5gf93gvdcKcKgs4qsvpM+PGcxB5QAyAF9VRuD4eZrD8dLQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-Q4+rexwN1dG7dJn3u7FqrImRqYtOS63p/fCP9e9wGosyLppDXEuEUzltbUs2S4wgyy3JB7V3jGOxaVIdv5a2hQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-ZeGIx1FuAcP0DSJSpA7MlqYOycu1oRWZbFw4XVO52IaKTZBPHTNe2oD53dMDcGy9B4bPEYISh0IsJsHZKg33bw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-SJyOke0VEzDr+23Ji7h9WXJLRWmGFzzbTj8lkzu76hnez7SVIm7lpS7fXZvgyI4lg9RlWKEFTg8A0btlXPAJAg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-2zrygwdsbrvPuXYo0+G3dNWtfDJwcLFC13YNSKhBxuVLEa9ByXCGN6Sj1oxRTN0o2UO+vNyrTFVARYgL9jeUQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-gmSRYVhh6xcXADj/K382C6QC3ZFbQtXf6c4P515y2g2qM9gJt3VvYUnNGi81+GdcibyatrQwBLLykWIj0828DA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-/uRDjVOY34yFzZIKTgXR9zrR5iQ9InlLvcU+6KvHQSETUUaP9YlzDfmjbIznvWsO81HRSHu8TczEundrAY9+xg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-MwcZGnqqMFzF6AM5btHljBLAv03KDe/FW4HJMC+nshVLzGAWzKKqRAIsHQS/RkZL96G+GwvgK6oK8EFloBYQug==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-+HIgeI6GhAV859fMPmT0ZPFXKV8rwBPMEJeFmKier55NxsB+fQOQHmWQGa5tUXpQp/7l10nn/Ve3oUL9SI8fCA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-JsNGNSAHS7ND5J4LgSh++kwCV7gDaXFQ9kr8heq+CDEc9tcW52sZOS5vSVa/jvqf1K+RotI3mn7onFMQHpF7TA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-q663wBF9/Hmott6ASqaom76AmQQzqSDJ7Y+1vQ/n1ljEH43LpfBYI0ymyVobKr765GdhkzcGt8QaEDhXHIMu+Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-ORbv4+iJNbmRDbsChjY+5OfYnvgrCZLbD0W0HHr4wvv+hv7lPsTEuIcsSI0jud4K62I8Oh9prb/ukrvBoMENyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-a41lbLSDpl/a9Tu0VK+VOtigzDUIRz9p09B5z5oi0Er3eENPuVNSuT5inaoszlEl4n4r79j4E67eGpux7U+d3A==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-CfrFZYFGDdIZT6b8zUTbbAg2QSrxOqrFjl/qp5ty+i1pe/waXQHkyNdsAJZ/6y6AK5J4bA2TjU6lxF02rRteQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-t9ccU6hJx6FrR5Q0AL1A9GqbFPJNdNjlU3Guiz40U3mLOCiYkaKu5BUH4aQf8Z74NpZtILlCfj503zgGv00btg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-3b5vei6Onmx3Ne1dX58eAJxr5IvJdZ1Zi1uqq3agpIWfHXWrNreIomE0Jn0YedDU0XdGR2vHY62ZbJ6gONNC9w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-blKKixiAQmto6PltSKu2ymkzVjBYP5QitPL/C4l8UXg5Hn+pC5/DpM2wzSoU4Ws4Adrc8kGCIopW3hbYmrcJJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-7ZQ5g8rfiFqASH4XJOAXD+N+5hNcfV5ZIuUXibqmHHh4VC0GujvtbDZEZSds/c2c3v5rDMY7lUyfCKWni5twPw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-4tSf0hFw6uw9i/psEgjQTKHgxGMGF2RPobteOX/K4oCDL5mhPTfutyPgjC7FgrQy0EkzOeH1Trql2ScAyrKc1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-JN7HkpEUsJhuerjRH+9KYhQ5EkvUE2uYQ6Q9791RVQM4MxY6WSBc6QJSlBokABePvIpot6KV77b35fBOlbn2Fw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-uj+RZ4dRWBeEpuoTL1l8rmbVjD0mf+IVXZnfQZ2Gd6AZC0pfMlsz1l99Obh1lpYRvhqwzacuSNOhh1eyNu1h8Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-1ZySy3R4aDB7a/WEJiWoRLM9rJD6nGR4oBw5Z13QPeQiEJUi8+RLKa3NzKF0gOxQ1kfKIqi7CthNK2TUChYTHQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-SG+iKTlMhL21oWeo+9OsbkJax/+Ay8DEYnQ/z4xWcPb5uWrn5IpiP670fg9y44kujNPaemGI2IVx173M6mLXCQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-jUOygO0DnaGbwvooR5W5YFdFYYfOM+AyK76c3wfRvk3+wszAJmU/LhglDc6v282JZzhETY/+iSTcbRFzCbG5/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-fIVmUOQ9IDzhFLQ2S4iacjEZYjhhAJcznZJN8uyXGkRACIn91YhX17Ftmh7SNN6xViXVzFkJesYlBz3GvFi+IQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-wBsp+j0/cyuQnp4nnFkzyYmnhIBK6eGyrn3TGDiAzgvZXP4qmOJa6mPCedyz/1kj0MjyZLDrlkEzDgdewg/4vQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-gVtL8UlQu72u7YqALJoms1jsstjF74CW5fIiV+clrm/TsD2lq/iXXqJjxpwPk4/XL8PH6hYSNRBbvsHGgNwa/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-OWEwwZBeO8N1dgtdKnTc3On1q+4zQ52dEv7l/dUzR3qJ8zTqCNkKrDVGHrWwSEaQGHdTO8sG+uy9hIUoosdL0w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-jTJnZPcTLX1D2qe+8jjnxuESEeYM7agzE5y6MHpVwT0hPtDZihxVQaQ/g2GKcv6YwAIPiCMtzimXHoBBkmwqig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-ZXLPu4jq332LWbu5+iTFqxsTcMjnmipSqi7jq2VOTrZ+WjRoyRELhKizw05gU5l+4ekM/nWN2Lcyg3yNLL1N9A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-aCNjHJbS0A6VUGuDJucZ5qBoWbAwwjCt3TFfZFAPqHYma3MiFNqQmyPWpKbFkqtJ8I6Gp0qJz1SJcmTz//+f2Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-YP005vToQyssYnj0N73vS487U3XMM4OAnyfFFXeFKO/ABMpCpXkZ8610rep1eoR94xBXlpfcu9GSj09x/AVwYA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-K0mn7ISf0UdAgs+xJwN5/3ANonaA2lyqrl40rpvpQwicO9cWfHlkqtbojGgh367WwDbR5qjoThZk7yexF4aMlQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-LwVTHcocVb+i51DLax1UtFIaxqMQugWt6VO9sZjd7RC0wYNZ+SY4vlp8a1UBthoN9FAmrbEZycAhDdFyXwJ8kQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-ooCNhlrQDMdYDv3NZ1tjmzrj89EZgNt1anf5ZW/JxR1IjwLJPx7vNy5W3plU5I44LnPRAbaR2MZiaBykjfhUaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-7E5CqZeyWSg4CtvqhmFPzZpNuEUG9FiUbrExs/yrKSMzpzzmwevHPjuinWEVoyBsfkVViETVovNW+m2JKydPbQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-qVwxFXINhMTz3CCy+aqLCS5HwHzYYhhpAAUNLfLoRuPVYXuHiglykEbSVzI8dz3TTEJiy45XmQg/x7qWYsX5kA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-LLUg4Ou28j9r9wdMuE93nuNM5bdydOtVWjS1uVe8d60SScbsbq5sohPQVnuzr02ZpXTlV8K63C/iYI5WIcMjeA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-7tzTmR9dzUyOQcGg0N6cts1r/ZN8uZ7E0a9+X7WwLfZafYN32gMQqeYQ+cA8RelYEM85SwK261czuI+4V+qa7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-iEmReIDThAEOB/0LIRy6zJZuRNdEc+1Jp6ENUZEJGnRjqq9mCaXrYDvmUd02DISzQ3Udp3IhmuMai4RK1x4XRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-FqkTFb6T8CiNkPeovvyzTO/zOBQvatukCKPKkyqabrqWSTxa0Y1F5TVQdhSziucrPfQ7FG/EBSGaVhCMaV5TUg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-DxIdcC4eHl3++CvoTBGo7oP+rbaUTrcI8Z7+S0GzTCXirRKQ2tZVZHYSk87ogKrc+Ari7OnozZA5V5grz8m/zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-65Id2z7SGWdPtAiaiBB25msJ5jmQ+behkMYbQ7b1nITkkvLfFGCNtmAuEyVJpNPxFRuM9Wyx0JllkuaByy4s/A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-UgeGWNbYGQfUuy8W/nqSfxfses2w3ZrZurqIX6z+3VY4+5btMEP+Rb1icoQ2VwIBpooZmivOBBMDK6yNdzUH5g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-5c7bsFUbvIJv2kFS4WTd9inqZxMUjJfWMJQvBI/9sceolnDdjVuHfS2WwT8rz0vHDJaVVRpwXXkFak+eJ6zjOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-9T7sgP9CBeVL9/iZT7EXNroot7iH7ttRwRtRK5fA1IbjZde44/kLs16UJD8XBSkCsCi6e9xjimxDFKpFy5duJA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-j4ZWTtwxweCI+Y8YcOWpILna4O7Fws9xugbNoLjQQUjDzOtPphkQfy/SqMewOh1rP/UlvhbOaK/xH70qlw1IRw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-0XMWCDhVCyFVtYSQKQcB1ZOYxkNLad3YGgcyALRw8d5DvSy/Pfy6x7isvT+K7ZSl70pJeHqW2XAWqdeUKeZ/gw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-UexF0shPIj8eCNqRRzDnUYoUTDjMP+UB4te7qasEyebRhNWcJFWQMh3zKDj3+I01vkAHlioVOzecZiYC0tYn5g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-oLhuJ4LYLhtjN0IAsQy575jCHCVnkCQCEeAKwbpFtYGeuYi+j3+2Pc+zgeXBTEwF4X6IPHk5VVQoITGgZJz/Ag==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-7PsYbP/YHuLMGKmX3efW4dYbh+LS3rSO9u0+HfWPiBxIGZ9oXdCIzd5WDfDYDFTi5FcNa45iEiqX5EAUnDQ/kw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-xcN+vXuFafGBgsLUbzZSI+GA8wAy6c1SEzIQ/TixFfkVczhSDPHzQNYkpSPeVPGpVynQ/RkmJHGeOAilNOevig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-CJ5Usxr2G8XfchBjNaE+PaZX8k9Ggmk6moCO3gziEBhvpVzN6ZOgN56qw2FU0kmNrMehazcRXPKifiEwzvxBjg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-EVTNRFfzop7GS0c5JoPQSFSaKPoZSviBekZ/cidrEL++4+VoJlwXXYQd8FJDsQuA/nm9KmflUSviZ7gXFMYSIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-a/WnRgdebHwoMQ5+uGh7Ljd0f1axwEiR353OtWgAs2TFBOHShvXL8GYTf2hlPEeXg8ZGaV7bf0WxRYR64j84xg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-lupO5plNzBSwTPuvQENbe3ZsdN3IVzdTYGE7ojpN/27jugCxhl71DXITiGdOtzaZ2rG/26LOATHPOSPsoE/eGQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-Mv5MV9BIy+vu1e6kRUMG31RUVTr3X8yoQruDqkSpvlwoySFiqWP7U7zLHFC2anvokxz7/OwF3zMMOl3h1wVR2Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-myrBKxO5VMSKsJZG6HKGYnXjhHIBg7aDplX3TiF4JwxH4rfEr/5RH9D00OcQhZnXr8FE9dh9ZfrBuTa4mRvEsA==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.6";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.6.26359.118";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-linux-arm.tar.gz";
        hash = "sha512-tVYPiYx64X/Khz/Gw1v7pqksLY1qwHFaPnUr2sIQbgkWCTyWtB6indSdBv6J370wDIlFcKqRT3Qv8w9IMZV1iQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-linux-arm64.tar.gz";
        hash = "sha512-va1sKKnYNfC5B6tl0u7ZaNs3SpizjSRJxxPSdkIA12qSsHiFS/UuQBEaykyaFQbT7TC4/oNT/6TapLQW7n1iRA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-linux-x64.tar.gz";
        hash = "sha512-xqRwHaW5ZvD6yOn3uqPmHFotmyNVcQYlMMaL/Myyp9dXof1KNG/+ZAPd7KaKXuTDaGG5c3KBfH1TIhshO4qQYw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-linux-musl-arm.tar.gz";
        hash = "sha512-HBG4VEvT0jlJ+koj5tvk0QiNJhbmcDWrbYbKWv7aGytBjsGuk4PgG3085q3JcJLA657JzZpmO0jXkIjeU9pGJw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-linux-musl-arm64.tar.gz";
        hash = "sha512-JZ050J1ZJQ7KuBRwzOkeDeqCvPP6ZJ72fezzrYREXihCUxnc/gTmlxeNePb4y22jDKZUPmmD6QaIa4RaTMCNaw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-linux-musl-x64.tar.gz";
        hash = "sha512-bbzrATeKmry9dwTdXP1u3o1YVXQY1s0lF5f/9+IMPRZe3dSDnr3PgguRLx5pHq7hQn9YSdo9y7AHWKomONYyFA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-osx-arm64.tar.gz";
        hash = "sha512-RSur/NlQOEcT5tozkwtPxQA41dFHTmE1Z5/wmXm8paTjSJbmb2XvZsGSh0w587+ov152/HEEenUEsL3QdyUcfg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-osx-x64.tar.gz";
        hash = "sha512-fdQMsBv1hip5TTJf1j6fF3vEBLHmHOZpd8hS11SunqaJCu0Uq1mIu/O7pmaSyksZ/KmF3kmHL6Kyr9w7G47Y/Q==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-win-arm64.tar.gz";
        hash = "sha512-CZx7WNNQGdISYvMRqtvXZ5OBDtgWqX9F+GfwfGm+YSl/vtoGyLKlDOmh38K1c5+pBPrkilyEFWhg1waL5sglVg==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-win-x64.tar.gz";
        hash = "sha512-Fd6/DUfn5oKIS2nQIcyqdF5dpQWsRH/tsciFDHl1Pun7NInAJQu6CbngQDdQ00n1E6pv1qWq1VDcAO7yJdrAJQ==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-win-x86.tar.gz";
        hash = "sha512-TiabF1UbUOxY5YdEkFhyKRJeqLABGDjt/zQc7uFy3IyRYxBXrYHJfsBnBiRoUv30jBtH8NKgy1kqVFvPeRZ+nQ==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.6.26359.118";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-linux-arm.tar.gz";
        hash = "sha512-o4IMtmrfzFHVy2Fig+HTBcei7gFNgK5fSCN9KdH4ARwwfJvtNfPxsapU8eYOfpbK27x+6X1DJgoMJVCixcSmRg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-linux-arm64.tar.gz";
        hash = "sha512-mT0KX2gn5sH9UH3sVQ/h17G06oBVeguODf0QGs7UYiZI5SbrcZbFJRRnptpHuAdCAPup+MjN8JDLPmIHzh1Orw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-linux-x64.tar.gz";
        hash = "sha512-zlUwwDFN041vG4NI+932U0HO4x4F6939eQaTfHhdeZwNK5X5INBFf13lNxvQ7emN+f2MlYjuWAKYZNWZ3W4VZQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-linux-musl-arm.tar.gz";
        hash = "sha512-hJBjviMNThZu6N4UR4kKAZomShoIKjy18K8vCk5bZ+du1u4G65WozfoT14pz1qETXHXkpBiaZVILBBqGQ0CITw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-linux-musl-arm64.tar.gz";
        hash = "sha512-1v/mUA0PAwDkNCQFmm+aw3pEw0KB2vvwMar9AAlPSI2M3oMO3tkUuq9sGdsQGldOMo2tVagsjYxKNPl8UviPDA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-linux-musl-x64.tar.gz";
        hash = "sha512-uoU77ujbyiGqVB1qDkY6fGPpqofvsHXitt5UZfBym7kUB8LnZR+csFR80jxOhn2EMKAhcIauGAhZ+7wNjUlVJQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-osx-arm64.tar.gz";
        hash = "sha512-zMiRl5xay3yh27cZOWf5E+Gk584ihcse+oWUBZDZtH9ogkjUzNagRvbm4rIw7bqcrE4TyreCgEy4qu/vgrb7+g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-osx-x64.tar.gz";
        hash = "sha512-NBZJ04R2nPpPi803RtD1dMzOmbSCQHk2RZBzv2V72pDhrk7Fr6TEF6NUP5j0BvIfiEP3Tg7+EHo+n3W+ITTu3A==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-win-arm64.tar.gz";
        hash = "sha512-UP55lMGCe45GsLk9bN5vK8nuBcs4nsUfBxwLj5kCLTFDi5jUeJw52J1eeN3b92WOxEu8y7n45RzM0TiqKchnaw==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-win-x64.tar.gz";
        hash = "sha512-mlqZrW46gQL9rsZOFspFevlzHpwyhRBv70kvrby0gQGJsUQKHa4kTTLTBrkqE6OAjvM5dVPIpOpO1FkTWwVkMA==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-win-x86.tar.gz";
        hash = "sha512-0Y+u3AJr4HBCE4MAjgUnmAWclbss/1ZEpmhEmsxyVrgbQY7NXrFbxQ/YMd35T2PGo+GjrzMHkIvp2dobAEV0Ew==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.6.26359.118";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-linux-arm.tar.gz";
        hash = "sha512-JXzSqyac/s0O9+Ps4DxBcof/VjPSSWYoMRn3ukw7gCSG++KN12zPIu73ce45OSohUKrE1vnvIVW/WZ9cfF6fgg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-linux-arm64.tar.gz";
        hash = "sha512-ewhYzLnuVaaWhYAV5dW3zI9uEbkGNM3HG9dmP5vwioGfcsPqHNQZm9OkeB6ZqdOu5YzSBKl0n6Y3LmtR8UeDUA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-linux-x64.tar.gz";
        hash = "sha512-jI/Oh9UzLdanQDwWuxJPZXVOKvstiZLMwdKVmzF3X8Q/cABPMXzHJFsLY+x0lZ8TehLv69dfoMbFhlNd5O2o4A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-linux-musl-arm.tar.gz";
        hash = "sha512-PJaK3k5KGRK6VuLiXtxw0IKiaiGT6XeztfEbPpYX8n8VcWbuG2LZzTE8WYa7ED2e0S2kvmQs28HI4zykVPCiog==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-linux-musl-arm64.tar.gz";
        hash = "sha512-sTr7e1C3eJRrIbbYYADZBkK4kLLRR1P8bp1/Fkqse+dv+Ar3Bksg1BHtsR3xo2CVaUcLrPmUSZl0obNEK3T0aw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-linux-musl-x64.tar.gz";
        hash = "sha512-mO5I151JSpEgLTYljdDzzH1bqPSYhnC05N6JwgGSTrJUxjIIARMyrmA0dtq0BUsON/iPWejOQMnWyaC5Tz2PkA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-osx-arm64.tar.gz";
        hash = "sha512-XYe2+sBM7NgSz1BNeKlQZEE2lRwwkGaprADQJyZ87ryYOYAcoJ3e1ONQk9N81mCqP7QL4eAkqISbut3X8RM+Wg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-osx-x64.tar.gz";
        hash = "sha512-ISZqBThnBu8/xPaoI2CchSes+IsSKZcWaLhkwqZ/90CVOut8b8meK+eZh0kYd2dwlMx3SiqJjlK21dUZC0ZxLg==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-win-arm64.tar.gz";
        hash = "sha512-kIYMjdFlM1YDx7qevSfOUSqOlHBZ6X+gOBdN9/1ZGo618kZibgBpv58FZrir/LvTSXaOwcrla/52udxCwqxmZg==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-win-x64.tar.gz";
        hash = "sha512-03fI4N1nHeXYPwWdL8Ee66fd3QQ+PLUC4e474aRiCeGDBqLbThI2YEMpVGORQ9/qQ8l2cg0YjGniukh9uBUACA==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-win-x86.tar.gz";
        hash = "sha512-GCZgT2AxsclHwIxaHRa0upyH/llORXHTmKeMsyC9GnBSuStHRY42DGuTS6hRFi8dM6bG4sH8KobYpnZaRprrBw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
