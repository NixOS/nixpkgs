{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0";
      hash = "sha512-T9BWMgotaWwAXEEVKvh+5ShetSaGVkGPnb9KTSJn12kOy7fsta1S/l99min5DOeeTdXQnz0M1CwoVwHS1iWBCA==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0";
      hash = "sha512-OSIHbLWOZLU9jSSEKDsGD36pHyqIAybehalwYddzO5MYAMR9yKGwKGWOFzPYvS/15zS3YsTqygJTkHYs1jNg0A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0";
      hash = "sha512-hs0BN6Xi9cxFmpaofsHtttL4TbY4TFm6DT5D/hE+UcCxDDZYv6ooQHypjLP5CdLidy1OyyUmwGvbuf+5JieaHA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0";
      hash = "sha512-ayOUxbNOZF/+5LIvk+x4a1MVWzezfT21L51sUNjrSPXI9hXyy1RhHGvnzzsFCaY2fcT++B7sXjY2mRtf/GFz9A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0";
      hash = "sha512-3rBJqAlEO+erUgcJ9xNRxB00kBSSsr2qKYuvRKFAIAmnqO3tGb3mv0/c1CWN6gyvzLhF9qf456oTDyE55yJ0vg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0";
      hash = "sha512-RkPFHxgjzoPhOne9ujHLjGj1PnxtWTUbuntGPA0tRp4mXzvTamWNqO5h5JUj2FmPsPWlj73wY5JBUVWtWi13/A==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0";
        hash = "sha512-u0pDMmOLuOqkCcMVWX0HO9OOdC+uU/tEgM7C/moTbrmFPJerQ2fbjEN7zNJ+KYtH4jCQ5XzTbIsoymdMAIr+gA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0";
        hash = "sha512-NmDXtioFmF/8XbCH/jTtoX8vGoa4Pw60vmqfsUHF9kiZ0eS88oOajDJcL/T+GY1NFUYqZlzP4v1euHO5Ew9WFQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0";
        hash = "sha512-GBpS42JV6HFr3UyQxF1l+4eHEpWsF+TfzkCqLMCRHTlZMVdRpPAYZ7ulGgJrOSWyEaonq8dfRcQWO921t65V1A==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0";
        hash = "sha512-Q+UdOC3WgtWBYQGeqZvXnK1yleWvjUATwO4dZ4jeyvZsO7o0MtuFEgLG7Zk4Rwpiv2kU/Hg6KG4JRZHNTrQzGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0";
        hash = "sha512-zt/Zq9OMgryacFiq7sXbUv71lG7Td/MpYDiUoa1BHUgauqWMOEuwxKjmn9lxKMxsUkUPtpA/7I4pYeJ2mwbZ0A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0";
        hash = "sha512-zZOw2mGIt6uffkMlPjjL4ynDNLQmlBxBmbic9sjNM/wmG/GTbirX7NaSXU4Gv2CUpEbfTE2EdI4sbmGPiSrU1A==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0";
        hash = "sha512-ne7KTc4ahag5Tc+bNUt13debOr34zkqF4QzG+6KmMpW6gEEKTkfpyYxkRYbbLYm/6RvfVD5qriMW+e5Bg/EeFA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0";
        hash = "sha512-q9MeJRsfKe7eUgy8lYqRQ8h05kbzpIICTdaxEhw0YgH6d9EV8XvO3/3z27JtmsVML7B7Pg7C6y1/+rNNapF2Vw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0";
        hash = "sha512-qb+zrVUr3PuuaoEdB7pTnJloY8CKdgR+tcPKJVuSJ46QK1LC3c1ipnuk0qfXu5uQA5f/r6+ADRvk3uMeqUbgEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0";
        hash = "sha512-T5SXOaUki+dUpBpK8cx19Mq7D+GDcFAhGjnlynmPWYxb2Fb0uHKJY2puaddWykc6Lk+p+9EYT6rqv8xS5DihOA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0";
        hash = "sha512-v+ZwkFL7RNA8zITberrf5S2VmavnnEsa1Qwjv59x+W/t13UOtGPadz9MqOotEw1kPqjw15FUL0tmidd8P9YWVA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0";
        hash = "sha512-jmd5E/MpDgZQHNuILvPzZWwmoO0B1ZpzFO0UZkOX4kwvOVZtFV6QKD8WRrNU/kc3KS8kIMEgsl6cdfUUyT6OTg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0";
        hash = "sha512-PXbtB4zdHlNDyd15huQP3jyl+Mg9ozNrrbLMOYybIz3SHu9pi6IRjVRYo4Wju2YDDF5MiqqVyC5X3IVEATqDww==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0";
        hash = "sha512-xJzsd0RejwW0QS3eeHdE7DOg0r9gChvOUdURR/2RgL5DTdr5EJv8mYnHsiKQ7RGI+oxy0zsvcJhoCkOOP7TDyQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0";
        hash = "sha512-nPMMPwd99663FCtMcny86KgvBHYrAN6sNAm7jTAEOrh/mhNWAKpaOKj6mcwapx3bCZsmhUbIBUuo9vBnwmu5Zw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0";
        hash = "sha512-HuQ7wOkzrG6QhKmKjx9bOmMQEuFtpLVc5XV2sD18WkqYDJFdhuLgU5MZx3Hv8eaMCMASA4YRuTuNVGkcaQmDpw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0";
        hash = "sha512-S/6imyAhWNQ5lauOZ6lkR8FzHeeHQQnghY3q2kLWaTScQQfAerUeOWT/wUgOGEOT1YUhdO/qtC7GSatCrF4ENQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0";
        hash = "sha512-q2E3tiO9/AYh1yaZID0XrM+BRHOzH1Pzyhx3wPRm7CuZbjJhIxLncEojAnKVcXqK+ljq8u/2IJMVBfy78of1FA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0";
        hash = "sha512-3JsDjxldjNm+dgfSBj2wPDvYii+1R8N7lAEe+cKp9UuNsmwMPw5RVS5y2HXaVhvH7WGMMTZ9tcSSJIJjeF9ccQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0";
        hash = "sha512-f+eY6ez6hHBY7d+Xv3YIHDkcEUpTwfDU9ktz8wgP57KuE4TmaS+QA0NTlJ6m9AxawTxhd3nmuz33tOu+3HZVhw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0";
        hash = "sha512-6AAOPY0b3eAZYafqusLl5dh5csK0bL2aP/j43N3Wd2uthXZ5rKX0zlEbJPWIdUeyEK++vQtrfndNkxNpBYEwRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0";
        hash = "sha512-BpdcM6l9Q2y2M3p7GHSNaow5C6oszJVc+8/aUkxIutXKUHJ8cAga0Wu1OdqXsV6SAqgwSXsQnUOt3Ixpb7MW1w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-TLN0UJ/TS7qOnCk1K6CEERu5dgU0Ni6yTBLKccKh3D999EV54cdQftRr7ZL44zumnd+ZH1ZqG6HwNkJUAWDx1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0";
        hash = "sha512-MY4SQcjqPI7mTBs93pFMGyyYHUKFgDvCRqLjHclQcWZzolwb4dby7qTdzWH3caaJe6ue/xQHt29gxpg1BVT5yg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0";
        hash = "sha512-V3VbsbAZcDWwyGK1HwrzQqA6ObroXDlHurPYzpvELA59drHf4FPv9XuBu5fZdhBiMpm/CVRlZSnLeVjdnpeZ2Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0";
        hash = "sha512-toxKEygvaPBAhMGIX5+yy9HsrVV5mbqJq2xlfJWs7DiFtqH1xBWlTdfdfHAyLZQkBr2WBYSpp4QDlmYQA/kWpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0";
        hash = "sha512-lTVX2CM57vfwDLs49QSjmRzalPWmilKqia9f0BTMHPnj9oJogZC01zJwajpPJwnEUAFQJ2BxjzA1n4+QASpw4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-NJs6HyiTYX38zWgaZtQsRRs8i1UHMyJRo4frCCTaYnFDL6Z+6pGyHIVry9Te0Ss8OJFrT2Wg3jL125JzkiTCWA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0";
        hash = "sha512-n3dxHlyoLZPOjeQ2Ueb/lgKmdjF7BoshmJWGcd3J5V5v4l6fO25McaMLJGR3OFWRa/dIlcCAADcg/FC4Ez7Tag==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0";
        hash = "sha512-7G7Rtb4wsazwSr4Q8XOwwfjfSPRw2id2hcKCGu58tuatIXSMVqFbbJqFfmdY4KugZgSKZEzK6q0J/4Lj7kY4FA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0";
        hash = "sha512-p9VMbSVN0vWAf1oj+NTm2Yuki5lU+7evJplPeiZ2C89B12L6Y2JrTAdzvETFKFzHPxn/4cRmy5tI4tJ/Ed5hbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0";
        hash = "sha512-92vCWKQbiW9T2QgCRTwiHVHpxpv8fDAOiCRUnlO9QkLhd2oWGKJt9zhHN4mbd7Al/WmBwD+tF0Jt8Ux5Ofox7g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-mYxTR23WyWk1zoEfXJsOeSL8MKNTE2hq4H5hzRyUcSmaOWi8EnO1Jwhss2LVf8MZ1PwSNcYHUAhGNTR7Sng9fg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0";
        hash = "sha512-16cihOE7A495QuTyafvX5omOfHhTKMsWGMjz/YcL+X5xo6eSaPLz0xGXCLnKK71JH5b4gtTa6pcU0K2GqNPtTg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0";
        hash = "sha512-olJxdcb99llzobwmN0i+5uHfp6eGlmZ/G56zOVknZaIjHJ4nmlYX90g8w4/gFR/5VSYgUQqNJN9lL0Et4KsT2w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0";
        hash = "sha512-gtT8FBMW46V/+AlxSyPdUrf2bUkKnYyuhHB2qRovyAmcI0xTWNJiLCPyAm2C7iJVhVjTtBXfnAdU9Yg/lmvdDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0";
        hash = "sha512-75py6MvojGH09EmRnzX6/7+vS9CP1ccdaYiJRAIAGp2QZkg3LxiVP4ucpp3FeXxsvPlgykskjREUIfYv4PgTMQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-7Z32KMPRiNiNz9hNfU9C1XD6nwCLvWweOUcxOPLgd0IOmlnXMrx/mWE+oxrALShoC0Um+a7uGtK95IHHi+xeoA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0";
        hash = "sha512-I0xdqbcpQ0r6dxnOPsZ98Cys0M3rYYM+rVCIEJa8FnmtBcm/A23ctL/rXqP37nfeHYYHFvGyHqquJ9H37bwKFw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0";
        hash = "sha512-xHa/iREYE9+eXD+5zzIp0zrdC36ynD1JCUgsvwcRP1aPPDXNBjBsWAxZ/QjTyg1maRodmQZuhGQaPPCQyhm5NA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0";
        hash = "sha512-htiAZf6v408Sy2KWvnr1OyG5iA3j1QVZU/skpgQBq9lVoeSH3W4VnenkIkGZX9rr9OOkp7ltlV3kRxJSiCTnNw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0";
        hash = "sha512-LKNz0mdfU3NScGQ0QA54EtXvNAgD1AHa8ikVFkBTXii9DRs2r0CepjWHQS/YNDPHP1WIqJ4kUvPG9y2i98yLpQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-tDB97RXC9g0LgXMmQKLUxcIWmVOrIT76M+hOScJSmdxfBuN8DR+vd0/Qz8x8jhL6V5GnFbMb4OzuRpMZBuCUjQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0";
        hash = "sha512-A8EYv/vgD5ZGS8MTTuSPjCZaxp2An1UTA5GHPtTTgw2cSy9aze16xCV66/shRaiaWmUl+Jfci7w9tGKj43jjtg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0";
        hash = "sha512-Kx4BBcdR5IRVCR9PDZj6BOMxOxAOha0P3m1G6ZpYHYjij16TBbnO5xDTD7kU6pakgX7OD5o2rkDzkgZd4id+VQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0";
        hash = "sha512-A3/hyuFwsTX8taXFYSAgsCBsmWpWSQqoZuMUntiFvEGByXQxXRN9Z+lC4Zi/vma/KAjaDbvEJ5wQzzHW0inYhw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0";
        hash = "sha512-HIKBjFeQGIggKEBjCjMjx+Wdz0eqS9LUCYscK6ikKK1LdzkGzhuGOccIitEcINu+RzYrZ4DoNGMRR8K1ZD04vQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-s8eS7o7sXq1LvSCbnd4pPFoVGXgnM5jS7Eoxq5vxCSHX6pUX/CP4e7StWgIMI1XL20Y6hMyoGKdhtJobBXx2OA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0";
        hash = "sha512-kF9DalxkiPeOjwyR5b8corgkVdReLaZDrqVOYJGse81Qwsc5hi3YeHqTNufkJciZ5GDVeYKil+0iNUzualTHkQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0";
        hash = "sha512-H/5FYjmxS6EavtoMjj0j46mIWnm6UcxN9wNoUS2kT7T6p4W3cDgo39EwIvICHF+9c9IClm8pJV8APiN5M/oShQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0";
        hash = "sha512-kPhRg+jIzNe2EktJ+SaJ9pxAG3yxx0CiFjfPJMdhsbOv0ulhVBw6YLXN87LSjxX8KijJPJC64lYEcj87BPi7yg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0";
        hash = "sha512-9T8ZXN3SkJm44FH8jTmnLzA0mko1En59lwP44/+EYFRE3XicwNA+jmMD/69YOHhRl7IU/AH58wtbCuBjVERKNQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-oBB753DpuMA40AwLZUkh1qaEwIw3jA5YunnkRex6ylrlyiOwWZ0E8qiPL/I34tYX49BVUeBLC1vN4FbPQTOcpQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0";
        hash = "sha512-m+K+2uqcmGRUYCLuy3yhbPAEaggNQAn8nrYogADqf1MtnosytxLihutOeMZ5zSSSjvs9VhEyrbnfH5/VdAkcRQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0";
        hash = "sha512-VhPErZwrz0HgWuCiMfQ+1gI9QrvmPvIygyepgPrKRQwRUwpQhjxcTcB//5IBJ3y/NUSxKdDCAA6EYDq2Bk77Zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0";
        hash = "sha512-ii0Rt6Vp8ZGrb6CdVU9BrSCWEB2AQzV51zvXS/PRVzS8Te2NcQ2WV7LFv/hn3mn9Oz3mLqnLLEK4pWX4LVWU/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0";
        hash = "sha512-q4K/FhMiozgVKxkxPeEb6TkotvLLEPdWXq+eZdDLlrqqVI5mkxI74dzlZEEvgxQTlXU83m1RRhqLZXkv0d1tgA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-8p2Qbm5xYsRADvOtxU4e5LP4+v8gvTNvDOkxMDuxwIq1mjx2JRTCktS/8DqbP60zPfQBcp1Kb3r905bR9pIULA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0";
        hash = "sha512-MxG82z6ujq56k7s/doOp+/4XDQ6fIAwkeo3HDAcFXtIXwMViEgu0Wo/iGwiw0MZueNNlXHNFYgAJHXmx0KHfKA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0";
        hash = "sha512-Iza+D5nqohrXwN4jbYSrkA8EMMzdmvjH6qDKUSgubYQhbXGhwplzOlbKCOuqWxs/FuqQlHQbA4gkxKBajecbqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0";
        hash = "sha512-gT3WiR0ggF8wtTOG7IQNXcCUUA92Y8XKKSj721nRUN3wjuTiWrXa+BeaOT6oiFA5qAe9SWkD2bCnhTddbFgpAA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0";
        hash = "sha512-AMtsb1rl/hpFfXVWujltjWVnBx9lBCxWOExGtvDwmQ5uEo+JBEqZiNrfxH1uTTgYWR6ul9DQnpCoIzolHUUaPg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-TV/2C3N2o5hXj5yJl81KJhI0C3tHVWSXx31ykLSE1ZY/MhzaMsrPNcStea3D1LMuNYI/wngUjQueJ/Xdr7yFHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0";
        hash = "sha512-GMxkSsYx3g2Lwc+i43chwdBIz5OXwwEBgPOBI3wh53pawGmdnPTJ1hHn5VQ1FocstZfs0UuagHum7qGwf6c+bg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0";
        hash = "sha512-t2qPSpfKVtJLBkX0DoJIM8DZAUq15usgdiLT/ebh2yqOUpYDURzAiWHY/OG3IjePNiRIvfS+Us2QH3uKhEhZMQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0";
        hash = "sha512-7Lo4roW0o2e3SlN2SkKRUvpYv2ibVid0vgNGFylLpGjNSwAwGR/Fe50uvqdtSF1TdKXMOut9P88Z3nTltRAL7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0";
        hash = "sha512-ZZQq6Upo0OyYCtNDsF/n4msWEOetdGlbPim6KMdKVQpJ+6pliMmVcw8sIIf7WJZhbc5FQAA9q9Xavs0I/RubSA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-BGeYTES8YukhLCp9s9OdvFd1Tkou7lCZEL7TFLVXxM4UgyOiAUowWSbMG/yWuQWL7gB9R6LwpzXicANhDspzBw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0";
        hash = "sha512-TxRXlVbdDsRJs2lvz6shwGv6PEJVPxRInv4vcvzrSl3DwZkW8OlQMN4a13nlmQPq8WIIeC03kBwY4XAi4tnAZA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0";
        hash = "sha512-9O/qEU4eo25ErNDwB3JhYuchjmDgFRvYYlBbkqujUOXcns1HUEI77YRyCNVW+sv4TKnJj/sr+FFB0gNPzF13Pg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0";
        hash = "sha512-no9c1EzoYHB4wIOZSTU0QGJOj02tFBt1f66ghlekAaAWWeXFA0dloUk/LYebqXLah0THIUEU/y4kBCm8LmYIVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0";
        hash = "sha512-VLNkRFjOYefmoa4qOokVczTCIr3Q76us7nkYSLCKv4F28P6zO9apUhmRrjfFXiSb4XcvBSF5v/0dV+B9rJVsTg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0";
        hash = "sha512-OjtaWSW+3LxAxlsaCGNiJrfuiffvWzbRka661XjSwoIdeY1KpKnlJxfkXoZFc1Xih+hzVG/aCMgYOm7xKe2yPw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0";
        hash = "sha512-ARpucuwr/Wyeme9rs+R7j4w+fu9E7gA8sEO5awiiC0Kvs0yagorS8D11nj7tB1LA3xQeW1U1si1X+BE8t+tdew==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-linux-arm.tar.gz";
        hash = "sha512-WjioFoxrJIIsd1XSgvz+uB1gKO1HWRK4ysEASZub3XWx7LYlBC7nI2CR0Oq1o3D43rMevuhOhH74Tl9b5NQA3g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-linux-arm64.tar.gz";
        hash = "sha512-EaYlxaFmJ8+zAXlWcPPuId60Cw0fFqykASUbO1qxAgXLXvhM2qJyWk5qmmJ+y57lgjGLdggVA5df7auITvfqSA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-linux-x64.tar.gz";
        hash = "sha512-T5TWWnxTS4LSUVPhx0DRqH2by8kYeTXWn7FPnd5fsoTmkwK94/4oGP+W6awMYtQ4Wqpo2Pbzy2ACqjnIWaJS8w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-linux-musl-arm.tar.gz";
        hash = "sha512-2Nt08XbC6dAHS173RpVl05/UBgOvJu9DQs1TndcDjsuFuwQuwgPdn6fGifN/lAIG4vi+/rzrdZO+H+w9YP1g6A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-linux-musl-arm64.tar.gz";
        hash = "sha512-EWPvcPxSGR3omNZMMYOhhdLtDtRP1htRKie482dPLHtzPaWOl+lJE1tMcr1zd5nnmwGQEa1JqAbZcL55OJ5jAQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-linux-musl-x64.tar.gz";
        hash = "sha512-Y98nxto8bg2V5XW5sXxlXkuSsGvsHsyZkiA1AdKfb5xyWK9LMb4KqpZZscfQ7P87OT+pyAtb//vfnQuVpigP6w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-osx-arm64.tar.gz";
        hash = "sha512-YC0BTRu8YnfUr8kqau4RwuqRdzlmmL6RuwHMuwQMqgq+jAaQuSq6vrCdZ6DrYgHCfiBq4kJRp3siyu7CcwyVbw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-osx-x64.tar.gz";
        hash = "sha512-zWNOAeqnJ1I+7JEzcGaDESGqtKoly+rTEab8C6A+o00hOLHYADgYO2xYRtNjk2Jr/6Xqa4hSabcrTBEKU6+U1w==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-win-arm64.tar.gz";
        hash = "sha512-FEgVl/NN625KG0rlF1z4wpDugm6X9JSkSPsA9q2R53ZbOsgwHiCPBSeiPNVRzL3L5sP0s3V0FQ08S/c67RvNvw==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-win-x64.tar.gz";
        hash = "sha512-TGH5DnQ47jcC7/GBUiMB/rYRPwkNokRwxWpu5n4hSCSWyjdM8UqCi77XyJF4RZYJsDEJfMVFT8qCgd8jAVjl0g==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0/aspnetcore-runtime-11.0.0-win-x86.tar.gz";
        hash = "sha512-NY/l54dnbAM8q+LG4ohUX5lkBUeo9p+/doQTwoBCDMBCqVgfh2oqh06z12ElKX/V/Q2jCbTU/Fu3HmNfqZq4yw==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-linux-arm.tar.gz";
        hash = "sha512-SFeo8sTsLyE4GRaSOyxqDpTWmtA4Cr/5pT9/magLUqALKiQ4yGUAsnVRBHIzsdQWraherSW5Y3yA6bgiJ0AI7g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-linux-arm64.tar.gz";
        hash = "sha512-tiTmR8cuj2Kg0YaqlqrRsRNzLow58BC+b5XsAm/rJjMYfjPyTDr1Fo2qodm0uwu5w5b20XLRhmC5Zzu1B/qfRQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-linux-x64.tar.gz";
        hash = "sha512-0IRuetSmsH/j+3wDOjgeaTjsFq++C390VP8vm1gkfLvDV1jMeFr0JDhcRXLIAQYMvWVqgi72JPSQfTzBChaggA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-linux-musl-arm.tar.gz";
        hash = "sha512-28oF4CpsIGyT0C/nrLbKn4Alqsyj0XsTg/JdwYt6PAnMLCEF0L6StqESc6W7Nw/21Wyuyl3ggF0SolH0pEiVyg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-linux-musl-arm64.tar.gz";
        hash = "sha512-ezLVPuHJgHj3HnO1EDMq7KenC5dPONkyAYV7qLiHDg0XXx0gaxXN4D/RReEwvPhufFdJ5n7+wg/2LeATIRn34w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-linux-musl-x64.tar.gz";
        hash = "sha512-heHShhBxmkQRn/cGuwnxdIc4CkfW0EAK2tcoiLos71XoDiVm0VsoEq9ELs3kadBdJy4V3tBNUV9ii0ClNFx4VA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-osx-arm64.tar.gz";
        hash = "sha512-HgmUPA/FgOR4FyaptyZLNeUFLHgSlhmxArKVlS9qh+GAXc6Fhk7aDdkTqzjaR2SbqWqAQ6Y43AvpeWhepvzHLQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-osx-x64.tar.gz";
        hash = "sha512-HlzCyoSZG1NyBRdAgjNq2UHhYS6j8WMZOtZ66UzyF1LPWQOdkiXPF0gWXk/rlclTWQC795EIFEvmEE3xROyl6A==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-win-arm64.tar.gz";
        hash = "sha512-iOLC3AIXzxwLY5qRt+9//ixHxCNuyGgF8FB/1bh3c5m6CVoTLxSTOjZSpD7GnovcJtmtqMUjljtj66xOUJOgBg==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-win-x64.tar.gz";
        hash = "sha512-FpdLf6y0FkOGeFqyR/yDI1olDnyXFo6vj0aquxiE1Km50jwLRCTn9HZJhSNw2jb5nOKXSGL254PF3ve4gI1k7A==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0/dotnet-runtime-11.0.0-win-x86.tar.gz";
        hash = "sha512-ioSjT63JVPihYrmDcXFXrWfafwF17wTZXv1nNaVnqkaIA/iZ8f7rl2HKRrfvTiVfD7hD06qeclyV5LJT3upC1g==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-linux-arm.tar.gz";
        hash = "sha512-KDDlzM8VKisqcmWA8dmXmbAbpBN5jzYu7K6hzQoQU12m9aaLNHfbiXJWTmP3+tNQu5QLo0UEH9A36abg4PlDUQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-linux-arm64.tar.gz";
        hash = "sha512-z6JIuxN3YG6GhgL7W01m+ha3VGFWWTk30ZgvfyFC5t7XbXHEom79q5n4fEarQMPGcqsbV+9/olRJ7+WxQKVa9A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-linux-x64.tar.gz";
        hash = "sha512-G+ycyi7GibHoAkW4TytTyUQdGqbazPLOsnSQdov/qVlU+lhb0nXe8xBp2HTVQ9m6nmWR/preLb2fNOxcD9AFDA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-linux-musl-arm.tar.gz";
        hash = "sha512-NZT4C+XcG3bvZTYEywBZbqSqoZiLza2xPjaPU08t6Jl8rTSsM72dz/ZzZFjLbynblE3tPIFA2fYpVEoj6eMt2A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-linux-musl-arm64.tar.gz";
        hash = "sha512-/+jfJ6h60avjkzOuliXVO/1BsZM99k2W55Vy3J50F2N5rCQZ+YnjK1QRe/hNsewTqI91e62Hh9wRJQGzpjFNsw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-linux-musl-x64.tar.gz";
        hash = "sha512-ttBC1L16mjX2NkjjPh0LOTeNWb1IjTBrkob2o+SP9gW0vQiQLj5N0jrkiccSLStdGBB3VYEkpj6Yw7A6VrJNIQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-osx-arm64.tar.gz";
        hash = "sha512-bIl44KjySgS2mlOf4p7fDGjjJH5G4kr7SSDuR54s4SVrF/3wYm+INbnHQ3hMCLQOyyWr3Y3Un8mdBA2vHdtN4g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-osx-x64.tar.gz";
        hash = "sha512-jpyINcTR7Y4wRfGgDlgxsCj7CQFh0ay+tuiyaILLeD/xirBPR4E0v1G1OPK+y7+ZlzfBjxfFaO83+5SpGgPWpQ==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-win-arm64.tar.gz";
        hash = "sha512-SUzOHXWKOn4o8gFAWNZ+BfhBcd+tOfZIEDCYlkRoxccnNugm6IEFBW9bJrq8wcq9HRRR39qRq6TwnG1FpuarnA==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-win-x64.tar.gz";
        hash = "sha512-m+7yiZjFDqoBH0JB/3HIxFDHaoVW7aCE0fmFfePWtdmxNhRKPhqYufmz4eL+ULBv/0wvO0Egh4CoAECIWQhFkQ==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100/dotnet-sdk-11.0.100-win-x86.tar.gz";
        hash = "sha512-X4+zKm8QxVUi7N4Qy6DkOEaAB6IP+ebXe93q4IswX6MwEACA5FN2hRW4vSHtWAXlsCbJGDiNVykFKHgfkfHmvg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
