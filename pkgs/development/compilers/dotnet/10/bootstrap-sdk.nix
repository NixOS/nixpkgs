{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.0-preview.6.25358.103";
      hash = "sha512-DF9lEJjcAAcQtFB9hLXHbQaLW82nb4xlG9MKfbqpZzIQfidqcAuE2GOug/q6NNDcw+N88J0p0jKPz+k3qKmAKw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-preview.6.25358.103";
      hash = "sha512-SV9nyI2/sg7Rh3f01eDScmjKYuuzI6xPX+iknl2zsecspqYBlWcPN1SvMDlaD/sK3GG5jl3hrM/GcOIqMpoFJA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-preview.6.25358.103";
      hash = "sha512-npMO7GioGKn0FigriTOCsi4HgSENnW9YRJYXhyFtCGLR7b71FDLVY8nHemM0XYm9lI0tH23N1EwcDFyzHTDuNA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-preview.6.25358.103";
      hash = "sha512-zDr+tWvnlB9iEwnAlfa3PW/S1/0nw1lhvXBWghgE6o9O5sxc35V3aobPAs+Cm6DTN+lvNMouhjPt6pn2t4PvQQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-preview.6.25358.103";
      hash = "sha512-W1yNC4+7vV1XPSXJx7HFsvFCi1C1XZ7QVlfbu+xq4pt1/0cVJGZaRlbwBNUAv4PAdg2JGM4VYtcr3ZreOJ1hzA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-IKe0SROzAWJiFZyh2KVmTU5i8ddcEqvr5NIr+3RfzvBEYa3SNBbqy1W1x0TR2aEvYgSqxKSohhs9YVSDlrlx0Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-5h33Uf2vFcjVkeNRD41YiERegQ7twv6sljYAMtz/kIHcIk90aB0ztZoKXXVi+vNxma7q/f5oPxhzUVidZ3vw8g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-yImkb4fnUJIXR2Me5N8eOrX7w9+u8SAAIp8QtlWdZ6WptjG6PUByTs2hjTfX/aVKjO4p1dmKTaWJ0qYR6yuDEQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-1FIBZLtWKIxULrRjLrldz6kwVSoAIf72kXKE0WgXECVez98NbQXLEM90hfpHj0LcQfzqOoP9kY48yRSoXp+rXg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-eMokXhxbTVJUHwlAhM1dVZmjljs/s1nRfvrJ0AeJaTbetXnD63Fd6sQeMmw/EifYnpdtxr/gIJRHLPsuLNDcAA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-qw5Xb2+l14q+2OSesjwGn3gHpdFj0wUeA3RLEUaljzW8FF5HD78B6t1YuhFJhcENuDNAv5d8Fcy4N1mG/RQZUw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-Etq6qbPIzEV8Z3+w0C1ibreDduKkAF1zZOGfvcBz3sjAC9sWs/qflxfKGZ7tBKhEV/A3vZWKNGyxYKnawCtC3g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-SINZNHzxrKbgD7VGAx9GDMIlMOmXSpqWIeLpmNpPTm2D7F+NfXv2lVLxLl0nLUAJ70ipI51HdHGyrKXTOaFO8g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-t2YTlMAHq+V8K8TnsFhUudCqiV5CElb/dk2tFmZ61Td4gyLY/iz+4q5lvpGAZOlCFddTtublSbIC3n4EH3liEQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-lEaH55DO++s5EKEHfODZkF279HI5DROQgaTif93wcMg9mhL5kPHnLhi9S7qTMFKt+GQfmZWMlwZd+L6GVz+RVQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-zuh5p3Hq0ejcgbCe3IaVOj+mItbRve25QdIXaGirOfDuO2a5fGXSO8RtgFosw8ar2jBSG3qL6loMFqqgkiEuVA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-Ivl/uKKvVrgGxfbC8SSz5N1NZRi39PQ5ZXfsECiSsiNR2ls02Wy2Icy5mLRUGCFY4FMILAKsgfJRKejafqGxyA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-zTiRlyK4ElT/MES3AX1bLRcuX3lY3NXlwL89YTyEjuHrqjCpxEbHfsoznqYd7zLAF1itzvNnxDkqDPoXat/zZA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-sSi6F1x2UVJe5Jp8RbURsNGVxFFPyxq6P8ZlV6r9dimYM2KkDyEOtcZ0hHSOtmMU3rghzZYksvSKv7+9fAYUNA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-Qj4yn5t5k+lGY8dBPwh0jLQOXoilcVvwpmyxJp8LJHoOM8EmGjRoiCy68sRXGTQMt5d3iNIdV93rX+fXu20rlw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-b26YbRN+y0LrdVq32iV7gUmi8sY4vY+P8GvaqiPTcJBH20OSfrsvDhyM08qMs6hCDo17xL5hFdLt9BSBfqcrOw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-IoNNvrZ/pKBwn/XSvDp1saM2XHk1ZOKxrA4lDyrL10/s4IS8hRo/Yv3qs+ihWpwVStORW3lh0YIxQhMDHbMkzw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-/D+xqMtDuo8ji4FPJm5EsEORBGEsbcHHYIjZDiEHP7ltIexg/oOSwuyvepvV+mK46Q4uyQU9zuBVZaG5FdKU0Q==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-kEXLQCzNVAnwkQ58qiO7lUOuO6WJSMlNmnQxx5o1RTiMIoqrgfjMazn5bpL5DPeZjMhWcB4kary/3Vkj06xRtA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-z0RiU5O+4aelPS7+JYakKFXrmczOzTYp5sptrRoz8H2zM0Tbvwc7sX3pT2F5ZosBEaub37XJKrwSdvpdHoe6/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-CRQl1RVkbfaLnYOEO4ApZ6Py1OG8zJjwU0UkAcIhg7MqsGgZcathISOzlDYayxqdbp+Gga21aaJJZbL0TSPkdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-UjSZtTgg1EEmNJeI+Esg2pMNjSb+lCy0VjwkUIVUJA6vezRNsb66NjsO5h4rvSMS2VhoKWGc7jbNV1AKRj891g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-h8mVEj/5JRPzKcDpoHvnQ0wt7nn7+euuPKLDtWH4yiAWztH8CX6udfHqjIE103USfpfMKEEcEWRqOe877rgp2Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-rXmRirmXSlmvrc4lY76+eK6UoXIi78sUSDggleEYs6Mwip1PWWQ1bg2Bi3tpxcRgF1MBOgHhiz37lybWaS1y7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-sw5cXyvNbbXyDkmnPJqNgSnOeDFdl9VL7OfA4kA2GcPCujXhnElVmF48rwibVtoYmDUe940zKPjUAeuXmmOH+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-BYeSSlt4ck/kK7L9I+OYdI+aklnF9JDNaHyIQ+nea+E/e6qqENxlgDPzJKwTKAX4XdIF7Rc/Gk14PuYBpC7+Ew==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-poxX0QwFAsVfHDfH85V0BVd5dEtlhr+/3rPhCe5qhkFscmUM31BcD1ABbzdxYt/PRJKnKMCCA/tOHhMU5rUieA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-kPsplrPdJ9VmThmB0kXTumkVG0WikMbkSRzGVyNU/Ploa9Cvv80PnCxF5VBAqRV1l/l3qBq9TZQV+7c6mIef9Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-LOoGtTUAg4/m9912v1s4yvh/wx64gRW6+052ZpHphizEbI/mvy5MGZpxS/WQHX34+RDXIG90CpdT7caL5iC1JA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-t10QcEDpbrSvoe2BhUCtqOAqfXayzy9uujpiIeAdOyptGmBppA37G+F4cCRsIx6wzhCSrdPkYoh1KzD4rqqlyA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-ykHn7VUDn711h67XQd+nx5Tn0L0vYWQY8kKWqqTXm/mBEM5CjoMd9qft6jirusGORVxC5RAnUENDt5n48B4xfg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-6G+05BJAEjErJMixdkEAndBjgaCe7WmasdRypKPtYRfzvPVExrq/nak0ZiaJ0Dd3WuYdbi69Qyeuhj7atnAImw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-xjepU2UUYCP30YJHPdX0PN6C0ZqP2RKAEsJWpnNSlYQ8fcDHgy+l5ZTQPBD4egfWKlPCEtgSZod3p9nTggSoDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-NORvYn5NilmBCZzLwrWXEPI7WeEKKwIHzh5USjQHQLsSoiWcOSZVKQLkqK2baSFjGktLyHmHRUQ6VnTggDuPeg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-tMM7GajJVqT1W1qOzxmrvYyFTsTiSNrXSl0ww5CYz/pKr05gvncBdK0kCD9lYHruYMPVdlYyBCAICFg1kvO7aA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-wUU31YeB3hCc41XTTSXbhuYKKSbFv3rQb4aO0d93B1m8xPZfUpYA121ysuwaaiPgHvFK27wfYBHAAO82d1Tbsg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-eQ28Igd0kDwNnBeaXvQul2U4Za4KTkBJ2hF5gi6/8xL8tJAIvpSiuHrcspBB7oqr9/uOU6R4eR7gDmOH0OVRaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-zHJSkQl00ygE1BBWjjSZgQmT+rpX/ZoNvU3az2Vfk0D9tqM4+zQ0M0IdBw0Eu1Wr46LeifWIScp4pTvzBB0R/w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-RaDmfdtde+m27g31HXvBUJme7NUUT07bv5+Wp3mPH/FXE6tT8W1DvG9XNRcT2rIEDq24ktpfyBiNbN8fieBfqw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-723qKUmFeBKN0yfsf9zhP3k5ZKqK4UYvdKbDL80oyhzm4gQZ6tsUU4fHeHjJVJfqyN+wKS+R0WthyxhA9m07/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-hPcjYztP9miyYl+mqvTqoEqaa+fp+kCFVrROIwUEDBMNs6Urk76qsWJWE/uI9kLBh1zTHiDsWlXDiOXcftVBxA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-IG7yOIrrLUvA22aUGR7g9VtXK3WGCsID9TokGqET+LoO4QTLlFRYjbrsUkvttuGUHftOTgDh+4abzkcqaTfd6A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-3PwE2oDr4+n93nPZbHz1kgJkpdus91UR5IXKnMWMMxcEq+VgNvNpU4+M+khwPOXSmxK9LY6dsd9beQVIFtrDVg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-QVYtaGiLQ0bWTiav/cc2Ps+PQ9co8EmTW8NAzlf835camz7gdjZHKo5/z4FOVUHVftCY9vn2yBuBcwceI6f+Bg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-4ktCvzYslGK2G2CLPy4As8rbHGPtQw0RA5VC9WxRmRpDH/3cyicFbRaBRVc2y19p0tV9nMC9KdaFyptm80lQZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-MPUbFdcUXGrfUpdNmcPvq+EdaBLcl+4+nsbUwftOT1041DpIUkFfDzgWNWVMjPG3Prf3K0iKPtvdKx9bdUlq6A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-CtxI7P/Il0bLfPXN6ofeL4Vm4ISp3TjvRBZt8MkACaTErFseNiwIIAKNqZ+d9lIxj1MDGA5fCfVn/0PsGIksRg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-p18BC5bG9/0ktSBUvxZOqPpr9qkS0Z6G71GViCAzjtV+fBllt6OE7T0rSvOZ14FjZFcSqMA2HZ60I3H93cK6TA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-T9Rhlb0Ivsaev2JNEKRLRoc5pyowBy+meS7GzijwfHOEviRw2rMpPNK+8DoygI8HRetSnjLghMlzdcfURF10LA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-7SI6G+CVFjxrcgJny64fmvOp4Pz02EXrhlKJdEKoht+enh8c/1pY55cgR5jq9GWJ9iJNtV9/sDUiADK74NWWKQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-ui1NVLgK7tEN1Xv+MO8FRovfg1OR4sKGf5GXHz2CN88GLkzznp5m9sSAETN2IPueRV+aaQ8JFaLEEw1QOdlh2Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-kTwrqjATCL5woNksB+G2B39lOIUkxLnouFruipzLnsDKSxG50pKIhxWUkrwTfwatL/zQasE+aVlwEfSQAxQteQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-86sGYDN7tFGBhAUacYgosah0TTIMT1czQtKHb6vKXOGo1wWAYa+MsGXrdUA6o3rpvybL8rbRANQ1tarIfui4Bw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-VkXVbi8EbajQYu5pge5VCXxWGhHJtLivHM+rqHt78b8w2IpYfRACV7lqEU1COg9D3sZEG5oLOzKLCCN7lSiekA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-CUdm0Uw4kGSk6oVm8QZLSwxngMFmbNoiFXve2hT0/Csu4mJe6ttV8C/Y0VLPBJr3GmoovOzMeH3coQfEf2YvBA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-kV1DnmxJrCauIvUfNe4wC4Yi888dzxxf7sYT4W/apnCSHvcjueYEZOGtoLSirsJJrn5aj9OeFVz+bAbd9nurxg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-XsP6i0SHVuDjS0IWBC+/3QXDJO+3ARuFbPSu9fRjR5NkK5/A4lQpBWJRymTzqWHzmD0DLYMEfwR+3mdG2A/StQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-UsW6m9/wuBUWM8SU/PHsn+9GQMRp4i00KfWDzE/s6rnCs40WRvy5Zcj923XMy05Bt04dhSrOOmDR1/vkydaysg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-Btz15yrqllW8cQ82bDOMB+fo1ONv4j+BvpZGQTt4zwqgyxq3qznnxVHrMxiG+UUwhDlD4ajCGYuZCjHECODTHg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-bVGv/VP4T598HMR97vrcF8NxOv43rTn4RtH5JSm/Z/I2l6Jf4OsEmrP7ciCJho65xgG2NN7E80dAfv6Waan/DQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-OvOg+DllupzQyo2AiWJOWhd3G7sXoROVbGIbaO48l3cXJf+EkT3mwK0WyKNJo1SYDBSHP4PL3CELLyl7KeuBTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-di/eQOCbK7Gckc/GaFEJbeHA8xc1sjPYb4ZgSDQG8s/lSc5EocnPG6YSiPu5noCS/kl4caLJzu8mcNEbHo9fQg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.6.25358.103";
        hash = "sha512-e4ZDOtOGLbKnCy90C+6+pAtkX/CJlAI3dPV3zF8Dtk4kCG6m+4TnbohG8z+CBaY4Tyh7HRXfCwA0sMhkZIhJ/A==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-preview.6";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-preview.6.25358.103";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.6.25358.103/aspnetcore-runtime-10.0.0-preview.6.25358.103-linux-arm.tar.gz";
        hash = "sha512-/mrP2TIr27NliznmIGDFdjriPeeSpDDbRyaM++1gNgJk55NQArHO3KgTMog2d5XlnTgkp03lH5lk3FQKgU2RiQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.6.25358.103/aspnetcore-runtime-10.0.0-preview.6.25358.103-linux-arm64.tar.gz";
        hash = "sha512-iGZ9ZtkKq6MGSfhNENBX2nwNtHnNs2t2gk3I4PAqRKa/XSaddNqg1reDdvLcZrYCOFWCZ1VeLO1Ay9BqrHRdag==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.6.25358.103/aspnetcore-runtime-10.0.0-preview.6.25358.103-linux-x64.tar.gz";
        hash = "sha512-FczqQ09eM7SvhyvaANMNP+5ElBE6Hl17HoziBqsKLgk4T6WiI6/d5LlOo7fhK3lsGkUTi+gzKIvWh0GuhD+2yA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.6.25358.103/aspnetcore-runtime-10.0.0-preview.6.25358.103-linux-musl-arm.tar.gz";
        hash = "sha512-HArq8wBlBcK/tkjyViWT9iu3pVsAULbMgecK6cwaNcrbv9VGEXBaGwv4SYqqNV0DeEfJ6nqa2j9YVWiLpqYTSQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.6.25358.103/aspnetcore-runtime-10.0.0-preview.6.25358.103-linux-musl-arm64.tar.gz";
        hash = "sha512-CH7Qk+rFkx3YjOnIF1Q/rEp/sAcF/+cet1U6/QoVtQfrWmO46FDhT+SI3t17OaCshkmaFU5oSBWpnBIjr1NJ0A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.6.25358.103/aspnetcore-runtime-10.0.0-preview.6.25358.103-linux-musl-x64.tar.gz";
        hash = "sha512-bU2Jk/BySlwwy7XDR9ovxoct3HUdvGykOI5/umDVFiZhk5g6mErGv+h5tEh4j3e6+1C5mWfe+6QD9E7j/ycx7Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.6.25358.103/aspnetcore-runtime-10.0.0-preview.6.25358.103-osx-arm64.tar.gz";
        hash = "sha512-VlWHBJhm7w4JIR0SLJUOPYfzvCL/dA5NVQYY1ppidjuN12bBNcC95Px8zLqmTzMhQrSQ0P1ClOTFjimCB49yBA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.6.25358.103/aspnetcore-runtime-10.0.0-preview.6.25358.103-osx-x64.tar.gz";
        hash = "sha512-c2tCqqrbhlRIvM/bOO2KlmCELsmPS4Trexq/E6imjPsWbx8dHZt6viROKAC0BwPUsxpQO+o2NZc5oEHjMsZSXQ==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-preview.6.25358.103";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.6.25358.103/dotnet-runtime-10.0.0-preview.6.25358.103-linux-arm.tar.gz";
        hash = "sha512-dkFn08ZTnl3/nj8Qh+pAs3urJy9+bB3gyGLXak0MNEUnmbRY6fpwMprijsbQfWtiSz9b0KooEubn7I+PavI7hw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.6.25358.103/dotnet-runtime-10.0.0-preview.6.25358.103-linux-arm64.tar.gz";
        hash = "sha512-cbydt+UH85l1JsTzkzkUYA+Q8AAxxhc1nzuAtyuBiljcgEpe2zTGt8qx4WVx6FVVRZUNGgcgv/WzGsY3RP204w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.6.25358.103/dotnet-runtime-10.0.0-preview.6.25358.103-linux-x64.tar.gz";
        hash = "sha512-f+rKqGVeFFIdtrqaeGByN38GOGTkGMXk9ep5kjop9HJO9u0WB0VFnuAo8ZJ5r6HA/t6atpM3IgiQnu+HM8oDZA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.6.25358.103/dotnet-runtime-10.0.0-preview.6.25358.103-linux-musl-arm.tar.gz";
        hash = "sha512-XXF9htD5Vt8lgTAnA9TYSNyBQjHnEpOgkOr1axgUYIRUOj1GcOQxDrkPOS4YKtAHycx8wfRRTQ76nfO2XRCD8Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.6.25358.103/dotnet-runtime-10.0.0-preview.6.25358.103-linux-musl-arm64.tar.gz";
        hash = "sha512-4mP7M8JBvsvY8vemP5tfQSPBpmfFVEfwOiSc/1SRs4pt+mKEURwPxidFxp8wK0ytnICIwnAJNYLX28p6LsZdCg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.6.25358.103/dotnet-runtime-10.0.0-preview.6.25358.103-linux-musl-x64.tar.gz";
        hash = "sha512-zf3Ek3pbRF4rjuks2odZedJWiUjdX+fQH4QwW2Mh3KZNZ+1hqYweccbaHu2CLwddC7BBBVGuyw+PPhMThDZ2qA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.6.25358.103/dotnet-runtime-10.0.0-preview.6.25358.103-osx-arm64.tar.gz";
        hash = "sha512-zXzElKrtYs2r8Sh6CMvDoPKPMRLoluA37YLYRdZThzJ+I0UlvxwESbA+8hhSM9RWL7Wfv9GdXyjaPgpnE3RTdw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.6.25358.103/dotnet-runtime-10.0.0-preview.6.25358.103-osx-x64.tar.gz";
        hash = "sha512-lm3Eezqhx6qSOzVI2IdkiCNpKwU/CT5PJrhmu/WAmx3W7zi9LC5RpOgPBsXb5K7Q21uuVSrZgmRi+sMOpormFg==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-preview.6.25358.103";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.6.25358.103/dotnet-sdk-10.0.100-preview.6.25358.103-linux-arm.tar.gz";
        hash = "sha512-lYjjTcixBEvdjpzqH9DWtWf+3w3br0iXsVOrmz6TrElXRXgQ+p7NfaTVo22KBbxItnCv0PUtTVbRQPdCoEOCCg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.6.25358.103/dotnet-sdk-10.0.100-preview.6.25358.103-linux-arm64.tar.gz";
        hash = "sha512-cwFkPqL72yWCUmxtRpnTy2V/bJDjzn8nRq1RwyCoSDwoDToV/C4HJgWyvf52NpBjo4T/Ydef+WRBg+SyHBundA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.6.25358.103/dotnet-sdk-10.0.100-preview.6.25358.103-linux-x64.tar.gz";
        hash = "sha512-ZivWGncnWokxhq7VsKbmamE9M2V/cQJqJ/dl8RlreOPzoq2ljhs34Prqw5qDd7Pps7zqK3LFsG3V2YSK2Yc/Pw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.6.25358.103/dotnet-sdk-10.0.100-preview.6.25358.103-linux-musl-arm.tar.gz";
        hash = "sha512-9E/Akg2mqGl07lLa7ODP/oyJEZPOmp1ob9k+gXiB7CSLkT5xdF7ldqZb9P3BZQZxivkERM7g9wFPuJZ6k6bMyA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.6.25358.103/dotnet-sdk-10.0.100-preview.6.25358.103-linux-musl-arm64.tar.gz";
        hash = "sha512-xK/vp5j5cN3jplkjwCZItn87VU5Rp94TstKSRoQ3EtCGRcj8IjpAi9N+Df17+HWA0EaM+nQAlexbNbknQG+Lnw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.6.25358.103/dotnet-sdk-10.0.100-preview.6.25358.103-linux-musl-x64.tar.gz";
        hash = "sha512-LCj610mZoxlInz08MT41eSP+UaQCG+01OZeA8trqlZzehNkYNdHjEMk71LfLaV+xT29lAa0LFmF0L/xYAVNiaQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.6.25358.103/dotnet-sdk-10.0.100-preview.6.25358.103-osx-arm64.tar.gz";
        hash = "sha512-xDIGEqUUEXVSocsTu6RBc72L25UGwTtLmmeumrCziq1+zU5d0dTDIwukn7luzRSyrzQWkp52UcXJkMv3ber7mg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.6.25358.103/dotnet-sdk-10.0.100-preview.6.25358.103-osx-x64.tar.gz";
        hash = "sha512-rWlkOrW5A00BlxcOx+TusNgSzeXwKKHq8X+w8gnOKyUZMrJBKNsMVfBXs+mv9n14vLBFmAiT+B2WlQMjYRpnlQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
