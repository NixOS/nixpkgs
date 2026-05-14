{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.7";
      hash = "sha512-Gf7BPLQGekD+oXoub+UqQdZTSk+Y7oe7+s8Z6R3EyJnk/JcJDCXVfyoWDYjY4RWNw6DztEHxqdw4HCLheeZpHQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.7";
      hash = "sha512-ax/0xF5bAuwsDwyO1hUr8FoESqEkw58JgqVnrF9gX7wMI+w/49lSFGLT5rEKABg2oCd1k4+rAnA4o7d6nHF/mg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.7";
      hash = "sha512-H2wX26dSDJNjseyuKnD4BttAz3+pFY7r5QUC+165DV6Fy5zl4vkhQCzW/CuDpZjvgJ7d/h/o5FpJC51S8BBOmg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.7";
      hash = "sha512-kLouD8cOoStNwIroAqsTOtKyLrHOGkoJKWit6VBMqnHG+JyKe/LIAoHFFm9RXlymIdD47ANutlmfUptqIMgLuA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.7";
      hash = "sha512-wpu6ojmbre4W8Z3L5UlTCCZ8XWD7KBqivC23bt3dhcDhGiefk2b0SkqPPc2hDWVJR6u6bNtOO3PJuX6mKT4BFg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.7";
      hash = "sha512-eqf4OnhoDCh9ecBVgRjfbLtx8gFU2Am8YFn4vG9fJS+bwtmDgH0/o2q5KjDYhnCcODoHtDGFDz+rjx+6wKgf+w==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.7";
        hash = "sha512-fiHBwcC0h66rHu+bHcSweipcnd3QHQ9PkMBo/HXCqPb6cDK/58pV6ZwFSX9+H5omldLa80jKHxWrfaSaEdmt1Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.7";
        hash = "sha512-V+7DGnggco8KCXGdsNsBk6FXpKrumk6P9gg3U4Bq/NCMXRQnw1lK1P/CRVGxnhSpU4ZPRAPiwJ19wYZUpfoSqQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-w2KQmyqmJPhv2ad7D3zVMOEv4Tp4WvDOGpUYHRSiLLidxdLmG1FMxmST46FkctOCczVropUBoYLJ1aZ8AKyHJw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.7";
        hash = "sha512-f94tNt9buVP9R1WSdiip3knUTPhRDnF/PcMsvCO+31vKp0zRza31Z6zz0HhgEsqZWUq5+7rF4FiQHo1h4osNbA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-iEOqzzRNCCpMGkj86R21xl5DerN6sJV0OGht/u6KYK3/jjhxNh5hBkS1xW0Ot7ePG0Q59sNuYTrpeLvj149YMQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.7";
        hash = "sha512-6Qgktj6xoboOywSjjkAGQ4FewF87cGFc18zp56E8z4kyBSOk0wM79KCPQrOe5MKVeHaEPQEvbvwVhIZkwqwqAg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.7";
        hash = "sha512-ZGLQLyhKxXuPyNsG6330/6Bt48zZiqUzWVDYaiMme7thodpy11OkMdtSCJLWJWzH9cLukJe8YuebOlLdTsKVOg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-yl7Ya0xaRRvCyoiyKiYYQXOG2DAVZVGG9biUpW1zSVWKOQg5iL7BQYaZg7WhcDVVeRPDTyC5VPf9gln+yJMM8w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.7";
        hash = "sha512-p5eA4ycxZp0DOStJGO6OBQGdJLqFkTpPBv8pZginrAN8lqWTC/DQmPP9yQFRVXecTZ5RgbUDSjO/fOBVHPDf1A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-QEaPTnKFte+SoB5+J7ySGHvOYgM1KB8cR7F74NxA9D4lOwJxDSSUgKjTkKY5BxOwqlrzLzyl1LLPeCT1M9AEWw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.7";
        hash = "sha512-Udp1ZVPMueL98kMWR/G8jA2ZZMtuwyiHJs3LSqEuM90SsT0zbo7khwWGpCDmzKpZEnjVmNGmP7wkk4fDySieIQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-6GgEcFXNkY88K/ns7rXVfOoKg8IlesaUKpM69Rw5yFqFoSRqg16oyy51b0jXhJzPGTT608KCKD/UBaofpa9sNw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.7";
        hash = "sha512-ShMydyfpyAraILh3iCfCe7MUJoaAjxjYxEvNcMkKfnl+0YrjdZv0msq97k30q2XOpyhlvI4wx1UEmp0Ca6YVuw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-v4fNH3zO6mJs4o7hhggzsmkRdlgQIjOM6dctVs++2wdeBI62R9jm7+NL4Mvv+5tlBPxHBNA+rgRXVei41P9PtQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.7";
        hash = "sha512-1DJD0k0hLlYCe8im/x51wMVKrSgJCVEVstt/9WXqBb1ZryIC6OIwuIiQpYL8uqZjOgXfHzLRGR6Nm9qKE556GA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-zVk5uCU0St7JeHitXNOEzmS1F+pe8QmREE8i1VK2ejNQGS+GEwAVADYQy0Kh9eZZjF6LBMwr+OkM2KNh1MPSEA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.7";
        hash = "sha512-Ckzj+ydnPySIMZXzGcZzg88Pa0/Z1zTb8P36Ebt+q+/7t4++EXgD/GLeNpcXBqyhVnfZTo+U2X4k7NdtUAI3PQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-XlMuELNoGKe4o0WZ4kCVDCDK+PWCuVkCWn5bvHu6+Dzu3Vgrkz6fpbEiueHo/JygAv6mJ7xuh3DmIFhcADLJZA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.7";
        hash = "sha512-egYUtga/dY/TdaCnAnvz2prLMKyhR1urLwy8oRjpz9H2zPoHGEwEUcYfvWsKQx329wqwKLbEb2tUf1kMXY9xKg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.7";
        hash = "sha512-W3jeXr/8XA+5GRuO54E2Z0+lzvnQjlUFKUG85OmuTuXBZq1lAYpx11wv3UWnThF5tpfCo/JQdKdlQmCUnT66Cg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.7";
        hash = "sha512-FWFqLaPZrzvDsMXg0gzehxd8pjn1qTwd/ztiJNbaQdfzb7J674FkNewdxYRNcHOKJ11efmC274ZwHYFfjytajQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.7";
        hash = "sha512-8AaRL1qvkqWPVjOHQwC0l/OaEW+kB55ZEPpVy+va9DsdKbacluwM6ntw1wyYMqDmT+RY3am3xowGC8BPTLXJfw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-H1Jb8J18xiMqKw/6wivEMjfarw8+vEwK8ka1JmhnEYzhtTXa+pI4ygsZZqpYo70QcAUqL6JA40aeLJeLs4FS5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.7";
        hash = "sha512-3WJjA3DvD1bOiC90bBCaD7uYRNxwlI/q9WqhJGPfQL0ev9J4IEbhnjDBnfHpvNcQq+94olv7uNULqDuF+0dFoA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.7";
        hash = "sha512-yvySI2llwH3C5SJu7nMPXdiMt9I8mE6yYe2o7uGRmLioYdavL8IWJTe0z+eHqUHBJNGTOecu4iXyewFyBnXRUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.7";
        hash = "sha512-CZtMaOZZBFNnUMzTt+32vISPd3EnlLy2SseAG7r+yjKMCToC8RAtd/Nb5brf5JGxqGk6O0XZgis/GLEdYS8s3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.7";
        hash = "sha512-l/M0JFy+BqVl0Vmh/7XW/uStC5kcJxs20RQXrB9gty1/1+jeMPtNjPMxQhX4l8IpnvxJKxHrQwS4fmGxeVLckw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-3kbzH8vl6k7kJmyFPpqg+TcC3S2pExh62dH0crOFhwHdrXzh10IKcWOEZA72YMkq1h+Q5Qx7tzhw7f/x9AXzjA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.7";
        hash = "sha512-OnV4dqKsgne7wa8fAnDcFd64j/rXnCinhIa7lZK8TkxE/VolLBj+ozTlZQnJRTvFRH3qWhCRCxuZ4quTm0031g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.7";
        hash = "sha512-AYjtoZuLypZi04ufOeo3Enf4auCuTh/O+tf3lYAcf9d5aK85eIHXteObsgf3+bzRgVV9Q8ZrNZqGzmo4ET6RrA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.7";
        hash = "sha512-cewXMAwMkxy7tJsWYDIs+/U8+e2k4iWB0rrWtengsP6gLrRLoMxPEKfgqcPUb8xqEKma12fXjlHSsNQ5w8o3/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.7";
        hash = "sha512-6M5WLHEgbkwRgIrVTNCiyKRZEXG6NdSpMHE6a3Eyta9dfnwORtTug/qFc/i0lHzKo7kcD/qSa0n8bIwvVi8alA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-XyNooMhkEvZOeD9LjL4l4q/2rZHnTBbJX0nXqAGkl9NusVZ32Sieh22NKbfq6VeVPpl39zkBAzW945ZInB5oIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.7";
        hash = "sha512-NouZIzCnL2D5ksEURgbwDbvfJEp3UG3GDrb1CYlMrIT9HloDuQrup0p0RTxDLvY8KjN9z8pkKA+UndECrB8fUw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.7";
        hash = "sha512-AaYA1bOWex13FUTKkmkBqGqrdTh3roqbjUN14aRjjKsvyEWfN1sUEgXkzSppS/3fs7nTAHK3NMgKtwDqjWBOFw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.7";
        hash = "sha512-o5i44nXKDcrMn+O+bLAVz6lxTmCGFQuV6NySNruE5P1Cxl4cLN4AxyCO7O+wAdA8T+LKsMDTJ7fS5e5rD+BunQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.7";
        hash = "sha512-7tqrmvF4S47ChWB4xZWZIaRo0jrdRqkEw5jyrgoh+CpIJZL1up4zH3TrDpuQqU9NwAqKkARS9v0n1bpsI2SKgg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-kl8Jo9paaMQ4ik1Qljlg8hEcnTPPR7eRfojoR8bRRG7Qdb5w+KfVt610iPTggbDPbqyxNGTU7JkYI7LC4iqLtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.7";
        hash = "sha512-rN/13GCBOpEyYDWZ9a8IdNj3XoWVo8keLvAxzCEHIdo61ofoehOkrqKd4nAzICJcahPi3GnpZ6cwgs6QeSEa2Q==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.7";
        hash = "sha512-Il39r2goFQsKhv1dMkcHZHO5qyHKeidhiWjPnUTem0vAxc5aQ+SuA0LluoqmOMNyMkjf9dcT2LFWA8WAL1m94w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.7";
        hash = "sha512-rsZBFUi9cydryfJbMExykLK4PJ9r6tiMtW9qW8RTXNaxw4mIOU91OawP13SNDLXRxKJxf4zWh67zs3Wd+pJt4w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.7";
        hash = "sha512-0/38WPpfkGB8jNRv/P/h9zOzmW9tA+wbTcIdywd7nz3MOr3ezlrvlUTZqy8//EO0YhF55dJxVYHK/v+qoWGJvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-2P1hgTVIOPQ+EPRXAvyG/dL/XOi3byg61DDtoRcVRjiDKIxQ+Kp9NUV+xU7z+0PleaWMu6kpr0PggCHHx3DBGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.7";
        hash = "sha512-Y73m/2fWqxv6Gj9iuKMyKgUFkQ4JEjBj9KKs5oQ6fSI9sW4G9FBVqKteszr+6F9J5zxHw09BHu06LSLK9O0HTg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.7";
        hash = "sha512-4PFWe3vISUFhfMWc2+RCXIEkFuYCb7aCrRuWF/MuOIHEAZrfa9o8jCESjCseRFJrgkFpVZ9S3JUe7xTnxYNxNA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.7";
        hash = "sha512-OFrMKJnf3HI4rbcg1yxm7QCdz20X8ZtzwshHx/Fx1UuXzecJwF6Y/LDefw5Iff/UIQq0bC8H3QD/NFqV2VAfwg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.7";
        hash = "sha512-VVgCm8sbMKhDoIdtaB5/dlhukHjbk1L2dJTojNWe+2c2D0G6uBtPEJ7x0D0DXYn8uxJQzk2sEetU0FPvF99K6g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-1m7ER7WC3H/tlboiWD1UOIgjAQbR9Umj44jqE9GRYok3MxnPJekzI2zD7iI6Ay5UFgpXP6xmvA9Dox65eTyIUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.7";
        hash = "sha512-9v2ckKCtY6Dgu3Tm/ojFsoEDdPDcbxW+XPp2hG8joEq3XMbRCDuNUPo+XWkXekthxSk1pDpfYmUF3ecJ/PfwUA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.7";
        hash = "sha512-qIDf88Gn7X3DyHFa8aoBvKjCyzS1DjIUbcYkTUTkNiOm0Wjbx4y1LWIhkQBbLIRyZYXtRllnVef2lp6lXC1DcQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.7";
        hash = "sha512-4wokP6wGw1Q9CeXIQmj64y9VJs4zETB8GAEX0lfv3HOJgaRA+1PU80qDEjkiG/n8I92PFcP2AYI+XIhUhFn0AA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.7";
        hash = "sha512-fG6yfTwqumXfgFem0ohTTMhaR4wu8GF/ZAQFxoPJckD254ybGLTrBM8F+/SXjjvZD+fezVIippCtU7vbIucztw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-YGuhrT3LwE1xKkxCZO13d6Nd2I50/i1t7Z2IfuRC2HWEdbbCPT+r2ZaSWoq6W/7q4Qm6Q1Y5EB6sIzAg6b/5pQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.7";
        hash = "sha512-pqXWdyhY8KTm0SO3vHkhXb6n5fWIKGb51k/0GLZqCPxc4CJ8bmjK3y7ps/sw7TUi6Iut8+OnOL3VsEHAT2aP6Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.7";
        hash = "sha512-X+dsme3aKiRQA4ZlmtziV0N/bjUZ/XNThRbHmfNy1eMQ+fhZX9nyh2qzgJlAFL8PajK/HdLDgT8kJgyGBla/Ow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.7";
        hash = "sha512-kBtKMk5UcAxvErG6FQkiNwHq0cDomo2v0GfUfrhd1h/AZfWyhNQDiKhrpjTXG7Ub3MFWVjpsTQXtzU3JJCRiMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.7";
        hash = "sha512-TLSsnX75VsuNe/RSqRU4bk6vUVUXaVAxv7gV/qld13TUkHpsIe/6sOtke1mQDe6wW4IlQil9se5XbSxL6D3k9A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-CWNXzdoE9Hv+p75M81rx6UmM4m3jDHvqJOYb6MSPkSyDOxffeSHv5xR05vYBTX9oWUyquJxPZvQ4fl5myzzR+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.7";
        hash = "sha512-R/SGs73Z5LpzfwBXz0qGecTFWMVBppU7D+hP6oAi5AWU/N9afccqDPp4x5hSn6L1K9LFI5z8dCOW3Diw0mJhng==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.7";
        hash = "sha512-nJMZXK37LvDspllFJu0fSNoReXeMOPt0/LGlX5FWkNnYix9VdmdgsjqKrOeAX2RVeNNwIC0+sP7PCGM4JXDbmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.7";
        hash = "sha512-W+Lqs/iBco9XsVJHQyPOEOP/+fLdRTAvyU7rGDBnYpvBYSa8kjX3z4vsoz3d6A1hPLcgLIPkNQBDwKX+2PjqtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.7";
        hash = "sha512-yRumRTvwYVpED8yQEml9H3h4uhb7hCZ16rAumQuRDOZbF6/kH+qCAiWU8Fu+kTaKeU6BEFfm+t9h4lrMFFZagw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-LkYzLczrxRP1D0BN0A3xkULppNn0NQdlZknZDiiKpJsPZZH9dGni+9tzUfsXIMqNG9o0XDa1U3nXQYve6yh8hQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.7";
        hash = "sha512-6ND+mgGFzzTugMT97ffy2puJTiKLhtmyMdgLw/UnmL6lXU655dnX8CJuvqI8KOuQPnLLNZ7h0GkEzCuC0lbk3A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.7";
        hash = "sha512-Pjr+XpDcUQPxqKgnF9rbU0ADgEXhHgyNuvZcJzzKKc4X1NaV688+sIVSBeHGZNvwk8PEmzxnjBsoBKMZXW+Q3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.7";
        hash = "sha512-uW9XlYNPtSF/4+sVgbR5rgqRUwudAzU6tfHKGkdW4vBhEQU7VGOKQK6KDHivcYSKKAef+LP0lT44eRgV0aHSuw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.7";
        hash = "sha512-PL1kRf9LOeD1eFBXXiqZ+2vlIV6LsI5D7tEvGvZxDOvp8hvA2iULFEb0mU6skGA/yDBT4Dr/XJ1JhV7HQWP2bQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-OczZHGOHTApFWcx8MFrepzZeN7qDy6hnByoJUXkRbEMVtXlYzP29UNcwxB38YMQDVeiLvd9GqyOg32iqw5oM/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.7";
        hash = "sha512-kkhmYV8OMVus/0jL4OYfuIVz1fLdHq297yYAiId2jHtV6rUHmMm1ThG5s8ZIk0JxBBP6JMlgU8cczjaPNeu5ig==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.7";
        hash = "sha512-Uje+J51MwnW9Djhhq7tA917T0H14NyDkZZKXpMIc0ik82dEqimk+pt74zyFQpqNbhFmAbNgXqFSytbENdWKN+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.7";
        hash = "sha512-bjeWG2AMv0gJxRcghFT+S9HheguHo8UzXegN//z2bjr3S0g2IhyLtZvnW1kT2OzfTjNEoMMqdAZxsFZXglOqRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.7";
        hash = "sha512-vJyCtsD2RG6A7ZrRPV4tsrucoICEHuWn1DnQR7T1dQGIuQ1rpot6PUrkfeD/NVTUnC5mb5lJnLdBfWdH3IMQxw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.7";
        hash = "sha512-nk01IpaPATaIVT/CJcKfswYkyvyp2dS55gR8xn5EoHnTntwc/nCMk21Q0uLtQlveHPE2y1x6UKcQp3G/YJyJ5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.7";
        hash = "sha512-lxQQPY3LyvWJdqc0/+ozjDFPeW+WB1imP8O6FQwX3/2BpY5ewIuUIbNbEE9CYlAILWJc57/T5+YI5iZL671Ypg==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.7";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.7";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-linux-arm.tar.gz";
        hash = "sha512-OM9v5LI+ANwyNtOhDxOlM/C6DCjdhZeWkeLpiTadl2D4Fq4viKhx+ccTicikr8kpNtrkLBpDHALOUVxahn1wzg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-linux-arm64.tar.gz";
        hash = "sha512-56F1ZBvs7i5t76l925YmHVMTfu1IXGL142eWC90LAS9xhVHSd+q+YG78/CJ1YB+6S0mekLpxu6sjxQ7/aI+fbw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-linux-x64.tar.gz";
        hash = "sha512-N4ok+0MnJ14KRgOb03GbAtLWsce/Sw68q8TdbGWoGMiXeQuKC3+hcSsCHE3QqX+ZX+YDf6krLpCeQyZlAdbPGg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-linux-musl-arm.tar.gz";
        hash = "sha512-ZwmmexmdAwGTJ/uKs4eyzpF97ITtyTY8lJODktGK06tUdx6lP7xrN2K+fzB1jDWd5qQcQ7tkYg3aeNlmE4/lqw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-linux-musl-arm64.tar.gz";
        hash = "sha512-7whP1bO5X0fHQoE2f3fZ7RktoC6uXt5BNeyIH4/5c9ul8q9QhgwnOUTZ8gle3VMHBVcOd4f7VTXNqJflgYuv1w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-linux-musl-x64.tar.gz";
        hash = "sha512-MyxlQ91Fq7SqEmWi78GE8oVQCTVsANvloZYPRe6sftd26/0Uplkrnd1MJrK2DyOrmhtjFyP0klg1JxakiRstvQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-osx-arm64.tar.gz";
        hash = "sha512-LUUxf6ATVowrhTTJE/qh+vLBcQBfMLGi73YjOVsL1B1jo6Y4V4cq9YnZLKq0dFl8vAelqTIOSi/9VD0zvMX67g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-osx-x64.tar.gz";
        hash = "sha512-QnAqJb5KWNoL3WRAa4GH82IqYmPpR46n0nGlK+GzUdyq0yG7s+2l5h/h6plA5bwq0CtKEM4ByR41O8H60g/cLg==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.7";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-linux-arm.tar.gz";
        hash = "sha512-bcG4DqodChDbTTUQWoxqNYt4dwPTNTKJ99n+DGry5kILuCqh9TVMln/C3byDqiI8m32dWGSgwr0M6GVoELd0zg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-linux-arm64.tar.gz";
        hash = "sha512-f0ttF0ZTnhlBXKmoCOROHyaXx3ox88XmaH7T/E2ddMTJNnsfJoE9Xbg0dEP3wrA92yUQGtzfzNItgOJ5bxMb6Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-linux-x64.tar.gz";
        hash = "sha512-cCOum1gDIlZsG+HcdxHMoNwY58iSGp3+RG3yeOX70S+F+c93rZd/rAoHKT2r0IeIFpNP0C2DFUWvn/XgeGpagw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-linux-musl-arm.tar.gz";
        hash = "sha512-CO6cNOQhRzhlMf2Psxw2nYYpZLeWwZvNKsnW6AiZEQQ5C6Rh84B0EF7FQ0KaO1NziJVcaGOpx2578mmJKHsAUA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-linux-musl-arm64.tar.gz";
        hash = "sha512-lKUGtfZKa9I8WYavkL7IjsyH9JpiSFR55LDiI/obCvejbw8dmpcGaqU7NArIouxlA+fc8eG0SQhAHoLHvi0xdA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-linux-musl-x64.tar.gz";
        hash = "sha512-5v7XQ6RNToYyqF6TZ9oz/mNb9ELZXdl5xA/dMIsXIQe3uulMMK8hEIJ6StevxI26vzbTOOtLViEFglDIAJknSQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-osx-arm64.tar.gz";
        hash = "sha512-zyoEOAsTjQuLBXSbWTWM9Si/i+3XseoxRFfatdjlPfzxTraRXk8z/r0pSj+A7+t+jKh5Q/S8LDMSfChZuyn9fw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-osx-x64.tar.gz";
        hash = "sha512-+hjhBy3r1VnMqd+347dTim5QZ0XLKPOwmotwrA9Mo0PorEc5wPnOShg5bfxEo1T6FcsDnvwcjtqS+l1jZoARQA==";
      };
    };
  };

  sdk_10_0_2xx = buildNetSdk {
    version = "10.0.203";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.203/dotnet-sdk-10.0.203-linux-arm.tar.gz";
        hash = "sha512-k8eS7a90ABi6VgW5riFn8B/mOYJRC15DgHL2P6IUrulaP8YzzwKKfMIKsLYBGdrK/u7CjmFpIXZrVviOIYprBg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.203/dotnet-sdk-10.0.203-linux-arm64.tar.gz";
        hash = "sha512-f7yOiyC21stAJpVE6ktekZ3X/HsGa0KfMuf6kIciTxdEW5DHgHxGdFzELymd1+9lq9AjvsA/w0HOB6W7UqWSGA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.203/dotnet-sdk-10.0.203-linux-x64.tar.gz";
        hash = "sha512-/cNqJyhbbzm2JYFEVPTdPnbyJZwSedAxfX+il1FLumB94yMpDULK9n9iuQgasmtu2weeAPK4xwnFgm0zSaRR2Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.203/dotnet-sdk-10.0.203-linux-musl-arm.tar.gz";
        hash = "sha512-jBDeHHtqPirDgc7xIc7besnwcbYBSWvfH+6ElWJ4QluLIH7VjCy3gjbMQP+tfiA0RKDyewIlWbWmt28VUejgpQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.203/dotnet-sdk-10.0.203-linux-musl-arm64.tar.gz";
        hash = "sha512-ZipU1imsyLzhHm+aRJfiBM5YbJhK+vqpHtYCB66mw6/GBomiRIogwUy8Dh7COo7A4isvijqJOZEpb7SjOcEoAg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.203/dotnet-sdk-10.0.203-linux-musl-x64.tar.gz";
        hash = "sha512-Bun9fhgR8LeUDrp94u/Pt6aS1psx6WOYvXXWPllUnD/mbeU66muc6s3pQKSVSpkxjCvbaHPfB+L8EHHWPV7wIw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.203/dotnet-sdk-10.0.203-osx-arm64.tar.gz";
        hash = "sha512-c94VjPlXjJfWquxkVFf3U5YVIoqZdPiFSBaDP7wzhh8x70jUd4Y4fuosHkXXzpbJirdg7J9bdgCdkdg+O4fANQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.203/dotnet-sdk-10.0.203-osx-x64.tar.gz";
        hash = "sha512-8ySt8E6sIi3z67m+G4JDBszBEr2crtBlfsZaHS5H3PUvhjxeEkpY167/X0/bmhhlYqr+zJoaxe5Mxh9GJijqDg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-linux-arm.tar.gz";
        hash = "sha512-vSE0MpXkFPmOcJItESz/a8ovNvZ1SCXHhSxvVB5cnDfIpEfbzu9Ub67RGcKtrWLtwD/8YudfIyT4Q2usbXSHaw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-linux-arm64.tar.gz";
        hash = "sha512-z17K1AeKJdO7cAa25J0ehhxx0l9hG2CaLR0yba6frnPfqgApC8BWJ2ltA7OVJjsSBSB99AAIIZ1I1WejUJK03g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-linux-x64.tar.gz";
        hash = "sha512-qS7ZucgZAsVLXgX6EO/80yWXa6srCzq0EoiXIwVunIuDcUtOlWsA+NLuMWQxKHt0rzmIF6ZyXEBsYSFG0KwRag==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-linux-musl-arm.tar.gz";
        hash = "sha512-ohcZciL8R1Vg0X+FsWsePyaCqEhx8H0euTuPDITpNVXQygJ0uJIODlua0BbPSAeowNQi3U7tk66RFAD7MK1ahQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-linux-musl-arm64.tar.gz";
        hash = "sha512-IQg9r+OOcFkc9p+Pz33RiCr/EZZvLyoWK6nfjcMikEqLCh6sGYBRsrUGCGrgZtL6++BkopdeX6S9nsPHAe26Fw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-linux-musl-x64.tar.gz";
        hash = "sha512-wKAz8hoSYTBOXxXP4eB7a165IiR+VV+xZ5fqIn55qinMKqnwfMm7KutAjLxtuXCHeuym7CdWuBgq/EuVyGtMwA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-osx-arm64.tar.gz";
        hash = "sha512-2votp+d9cf0n+v+/dGJwK4fa+N/Zsxe6KKpljm8r6en9dpJRsUYisSEAV18ZUz/ld5BH4U21JYR2NlVmGyx/Ag==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-osx-x64.tar.gz";
        hash = "sha512-d4ZRhVsewSjPbTB88l95nxPenws1cYJPBojkqrIbgZLM4vLd2AsgPZQHEuNeVs306HNHjr9O/2qn2OE5V7dddw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_2xx;
}
